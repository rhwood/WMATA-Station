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

    public init(_ information: StationInformation) {
        self.information = information
    }

    public func lines() -> [Line] {
        information.station.lines
    }
}

extension StationModel: Identifiable {

    var id: String {
        information.station.rawValue
    }
}
