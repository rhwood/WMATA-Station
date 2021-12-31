//
//  DataCache.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-10.
//

import Foundation
import WMATA
import WMATAUI
import os

class LinesStore: ObservableObject {

    @Published var stations: [Line: [Station]] = [:]
    @Published var stationInformations: [Station: Rail.StationInformation.Response] = [:]
    @Published var walkingTimes: [Station: Float] = [:]
    /// seconds to wait on failure before trying again
    private var waitTime = 1
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "LinesStore")
    public static let standard = LinesStore()

    init() {
        for line in Line.allInMapOrder {
            stations[line] = []
        }
        getStations()
    }

    func getStations() {
        if let informations: [Rail.StationInformation.Response] = CacheManager.standard.retrieve(name: "stationInformations") {
            getStations(informations)
        } else {
            Rail.Stations(key: ApiKeys.wmata, line: nil, delegate: nil).request { [self] result in
                switch result {
                case .success(let values):
                    waitTime = 1
                    DispatchQueue.main.async {
                        getStations(values.stations)
                    }
                    CacheManager.standard.cache(name: "stationInformations", object: values.stations)
                case .failure(let error):
                    print("\(error) requesting stations")
                    waitTime *= 2
                    DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(waitTime)) {
                        getStations()
                    }
                }
            }
        }
    }

    func getStations(_ values: [Rail.StationInformation.Response]) {
        for information in values {
            for line in information.station.lines {
                stations[line]?.append(information.station)
            }
            stationInformations[information.station] = information
        }
    }
}
