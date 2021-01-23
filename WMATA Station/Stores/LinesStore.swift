//
//  DataCache.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-10.
//

import Foundation
import WMATA

class LinesStore: ObservableObject {

    @Published var stations: [AnyHashable: [Station]] = [:]

    init(preview: Bool = false) {
        for line in WMATAUI.lines {
            if !preview {
                stations(line: line)
            } else {
                stations[line] = [Station.A01, Station.B02, Station.C03, Station.D04, Station.E05, Station.F06]
            }
        }
    }

    func stations(line: Line) {
        if stations[line] == nil {
            stations[line] = []
        }
        line.stations(withApiKey: ApiKeys.wmata) { result in
            switch result {
            case .success(let lineStations):
                print("\(lineStations)")
                DispatchQueue.main.async {
                    for station in lineStations.stations {
                        self.stations[line]?.append(station.station)
                    }
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }

}
