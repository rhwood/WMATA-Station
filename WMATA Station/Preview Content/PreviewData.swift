//
//  PreviewData.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/24/21.
//

import Foundation
import WMATA

struct PreviewData {

    static let preview = PreviewData()

    let stations: [Station] = [.metroCenterUpper, .judiciarySquare, .farragutWest]
    let stationInformations: [Station: Rail.StationInformation.Response] = [
        .metroCenterUpper: Rail.StationInformation.Response(address: Rail.StationInformation.Response.Address(city: "Washington", state: "DC",
                                                         street: "607 13th St. NW", zip: "20005"),
                                                            station: .metroCenterUpper, latitude: 38.8983144732, longitude: -77.0280779971,
                                                            firstLine: .red, secondLine: nil, thirdLine: nil, fourthLine: nil,
                                 name: "Metro Center",
                                                            firstStationTogether: .metroCenterLower, secondStationTogether: nil),
        .judiciarySquare: Rail.StationInformation.Response(address: Rail.StationInformation.Response.Address(city: "Washington", state: "DC",
                                                         street: "450 F Street NW", zip: "20001"),
                                                           station: .judiciarySquare, latitude: 38.896084, longitude: -77.016643,
                                                           firstLine: .red, secondLine: nil, thirdLine: nil, fourthLine: nil,
                                 name: "Judiciary Square",
                                 firstStationTogether: nil, secondStationTogether: nil),
        .farragutWest: Rail.StationInformation.Response(address: Rail.StationInformation.Response.Address(city: "Washington", state: "DC",
                                                         street: "900 18th St. NW", zip: "20006"),
                                                        station: .farragutWest, latitude: 38.901311, longitude: -77.03981,
                                                        firstLine: .blue, secondLine: .orange, thirdLine: .silver, fourthLine: nil,
                                 name: "Farragut West",
                                 firstStationTogether: nil, secondStationTogether: nil)
    ]
    let stationModels: [Station: StationModel]

    init() {
        stationModels = [
            .metroCenterUpper: StationModel(stationInformations[.metroCenterUpper]!),
            .judiciarySquare: StationModel(stationInformations[.judiciarySquare]!),
            .farragutWest: StationModel(stationInformations[.farragutWest]!)
        ]
    }

    var railPredictions: [Rail.NextTrains.Response.Prediction] {
        var predictions: [Rail.NextTrains.Response.Prediction] = []
        for idx in 0...5 {
            var minutes: Rail.NextTrains.Response.Prediction.Minutes = .minutes(idx)
            switch idx {
            case 0:
                minutes = .boarding
            case 1:
                minutes = .arriving
            default:
                break
            }
            predictions.append(Rail.NextTrains.Response.Prediction(car: idx == 3 ? .six : .eight,
                                                                   destinationShortName: "Wiehle",
                                                                   destination: .wiehle,
                                                                   destinationName: Station.wiehle.name,
                                                                   group: "2",
                                                                   line: .silver,
                                                                   location: .metroCenterUpper,
                                                                   locationName: Station.metroCenterUpper.name,
                                                                   minutes: minutes))
        }
        return predictions
    }
}
