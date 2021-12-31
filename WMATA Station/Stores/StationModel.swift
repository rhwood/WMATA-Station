//
//  StationModel.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/28/21.
//

import Foundation
import WMATA

class StationModel: ObservableObject {

    let information: Rail.StationInformation.Response
    // meters from station location to search for connecting services
    let radius: Float = 500
    let metroNextTrains: MetroNextTrainsModel
    let metroNextBuses: MetroNextBusesModel

    init(_ information: Rail.StationInformation.Response) {
        self.information = information
        metroNextTrains = MetroNextTrainsModel(station: information)
        metroNextBuses = MetroNextBusesModel(station: information)
    }

    var lines: [Line] {
        information.station.lines
    }

    var station: Station {
        information.station
    }
}

extension StationModel: Identifiable {

    var id: String {
        information.station.rawValue
    }
}
