//
//  PreviewData.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/24/21.
//

import Foundation
import WMATA

struct PreviewData {
    static let stations: [Station] = [.A01, .B02, .C03]
    static let stationInfos: [Station: StationInformation] = [
        .A01: StationInformation(address: StationAddress(city: "Washington", state: "DC",
                                                         street: "607 13th St. NW", zip: "20005"),
                                 station: .A01, latitude: 38.8983144732, longitude: -77.0280779971,
                                 firstLine: .RD, secondLine: nil, thirdLine: nil, fourthLine: nil,
                                 name: "Metro Center",
                                 firstStationTogether: .C01, secondStationTogether: nil),
        .B02: StationInformation(address: StationAddress(city: "Washington", state: "DC",
                                                         street: "450 F Street NW", zip: "20001"),
                                 station: .B02, latitude: 38.896084, longitude: -77.016643,
                                 firstLine: .RD, secondLine: nil, thirdLine: nil, fourthLine: nil,
                                 name: "Judiciary Square",
                                 firstStationTogether: nil, secondStationTogether: nil),
        .C03: StationInformation(address: StationAddress(city: "Washington", state: "DC",
                                                         street: "900 18th St. NW", zip: "20006"),
                                 station: .C03, latitude: 38.901311, longitude: -77.03981,
                                 firstLine: .BL, secondLine: .OR, thirdLine: .SV, fourthLine: nil,
                                 name: "Farragut West",
                                 firstStationTogether: nil, secondStationTogether: nil)]

    static var railPredictions: [RailPrediction] {
        var predictions: [RailPrediction] = []
        for idx in 0...9 {
            var minutes = "\(idx)"
            switch idx {
            case 0:
                minutes = "BRD"
            case 1:
                minutes = "ARR"
            default:
                break
            }
            predictions.append(RailPrediction(car: idx == 3 ? "6" : "8",
                                              destination: "Wiehle",
                                              destinationCode: .N06,
                                              destinationName: Station.N06.name,
                                              group: "2",
                                              line: .SV,
                                              location: .A01,
                                              locationName: Station.A01.name,
                                              minutes: minutes))
        }
        return predictions
    }
}
