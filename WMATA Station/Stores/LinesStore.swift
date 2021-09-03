//
//  DataCache.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-10.
//

import Foundation
import WMATA
import WMATAUI

class LinesStore: ObservableObject {

    @Published var stations: [Line: [Station]] = [:]
    @Published var stationInformations: [Station: StationInformation] = [:]
    @Published var walkingTimes: [Station: Float] = [:]
    /// seconds to wait on failure before trying again
    private var waitTime = 1

    init() {
        for line in WMATAUI.lines {
            stations[line] = []
            stations(for: line)
        }
    }

    func stations(for line: Line) {
        line.stations(key: ApiKeys.wmata) { [self] result in
            switch result {
            case .success(let lineStations):
                waitTime = 1
                print("Got stations for \(line)")
                DispatchQueue.main.async {
                    for station in lineStations.stations {
                        stations[line]?.append(station.station)
                        stationInformations[station.station] = station
                    }
                }
            case .failure(let error):
                print("\(error) requesting stations for \(line)")
                waitTime = waitTime * 2
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(waitTime)) {
                    stations(for: line)
                }
            }
        }
    }
}
