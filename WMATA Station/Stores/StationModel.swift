//
//  StationModel.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/28/21.
//

import Foundation
import WMATA

class StationModel: ObservableObject {

    let information: StationInformation
    // meters from station location to search for connecting services
    let radius: Float = 500
    let metroNextTrains: MetroNextTrainsModel
    let metroNextBuses: MetroNextBusesModel

    public init(_ information: StationInformation) {
        self.information = information
        metroNextTrains = MetroNextTrainsModel(station: information)
        metroNextBuses = MetroNextBusesModel(station: information)
    }

    public var lines: [Line] {
        information.station.lines
    }
}

extension StationModel: Identifiable {

    var id: String {
        information.station.rawValue
    }
}
