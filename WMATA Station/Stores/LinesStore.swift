//
//  DataCache.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-10.
//

import Foundation
import WMATA

class LinesStore: ObservableObject {

    @Published var stations: [Line: [Station]] = [:]
    @Published var stationInfos: [Station: StationInformation] = [:]

    init(preview: Bool = false) {
        for line in WMATAUI.lines {
            if !preview {
                stations[line] = []
                line.stations(withApiKey: ApiKeys.wmata) { result in
                    print("Requesting stations for \(line)")
                    switch result {
                    case .success(let lineStations):
                        print("\(lineStations)")
                        DispatchQueue.main.async {
                            for station in lineStations.stations {
                                self.stations[line]?.append(station.station)
                                self.stationInfos[station.station] = station
                            }
                        }
                    case .failure(let error):
                        print("\(error)")
                    }
                }
            } else {
                stations[line] = PreviewData.stations
                stationInfos = PreviewData.stationInfos
            }
        }
    }
}
