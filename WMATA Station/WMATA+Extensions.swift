//
//  WMATA+Extensions.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-12-31.
//

import Foundation
import WMATA

extension Rail.NextTrains.Response.Prediction.Minutes: CustomStringConvertible {
    public var description: String {
        switch self {
        case .arriving:
            return "ARR"
        case .boarding:
            return "BRD"
        case .delayed:
            return "DLY"
        case .unknown:
            return "---"
        case .minutes(let minutes):
            return String(minutes)
        }
    }
    
}

extension Rail.NextTrains.Response.Prediction: Identifiable {
    public var id: String {
        location.rawValue + "\(line?.rawValue ?? "")" + group + destinationName + minutes.description
    }
    
    
}

extension Bus.NextBuses.Response.Prediction: Identifiable {
    public var id: String {
        route + tripID + vehicleID + minutes.description
    }
    
    
}
