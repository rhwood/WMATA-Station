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

    init(preview: Bool = false) {
        for line in WMATAUI.lines {
            if !preview {
                stations[line] = []
                stations(for: line)
            } else {
                stations[line] = PreviewData.preview.stations
                stationInformations = PreviewData.preview.stationInformations
            }
        }
    }

    private func stations(for line: Line) {
        line.stations(withApiKey: ApiKeys.wmata) { result in
            switch result {
            case .success(let lineStations):
                print("Got stations for \(line)")
                DispatchQueue.main.async {
                    for station in lineStations.stations {
                        self.stations[line]?.append(station.station)
                        self.stationInformations[station.station] = station
                    }
                }
            case .failure(let error):
                print("\(error) requesting stations for \(line)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.stations(for: line)
                }
            }
        }
    }
}
