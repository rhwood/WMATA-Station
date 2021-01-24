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
    @Published var stationInfos: [Station : StationInformation] = [:]

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
                stations[line] = [.A01, .B02, .C03]
                stationInfos = [.A01: StationInformation(address: StationAddress(city: "Washington", state: "DC", street: "607 13th St. NW", zip: "20005"),
                                                         station: .A01, latitude: 38.8983144732, longitude: -77.0280779971, firstLine: .RD, secondLine: nil,
                                                         thirdLine: nil, fourthLine: nil, name: "Metro Center", firstStationTogether: .C01, secondStationTogether: nil),
                                .B02: StationInformation(address: StationAddress(city: "Washington", state: "DC", street: "450 F Street NW", zip: "20001"),
                                                         station: .B02, latitude: 38.896084, longitude: -77.016643, firstLine: .RD, secondLine: nil,
                                                         thirdLine: nil, fourthLine: nil, name: "Judiciary Square", firstStationTogether: nil, secondStationTogether: nil),
                                .C03: StationInformation(address: StationAddress(city: "Washington", state: "DC", street: "900 18th St. NW", zip: "20006"),
                                                         station: .C03, latitude: 38.901311, longitude: -77.03981, firstLine: .BL, secondLine: .OR,
                                                         thirdLine: .SV, fourthLine: nil, name: "Farragut West", firstStationTogether: nil, secondStationTogether: nil)]
            }
        }
    }

}
