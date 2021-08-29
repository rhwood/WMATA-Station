//
//  RecentsStore.swift
//  WMATA Station
//
//  Created by Randall Wood on 8/28/21.
//

import Foundation
import WMATA

class RecentsStore: ObservableObject {

    @Published var recentStations: [Station]

    init() {
        recentStations = []
        let recents = UserDefaults.standard.stringArray(forKey: "recentStations") ?? [String]()
        for id in recents {
            if let station = Station.init(rawValue: id) {
                if !recentStations.contains(station) {
                    recentStations.append(station)
                }
            }
        }
    }

    var lastStation: Station? {
        if recentStations.count != 0 {
            return recentStations[0]
        }
        return nil
    }

    func addStation(station: Station) {
        recentStations.removeAll(where: { station == $0 })
        recentStations.insert(station, at: 0)
        while recentStations.count > 5 {
            recentStations.remove(at: 5)
        }
        let recents = recentStations.map { $0.rawValue }
        UserDefaults.standard.set(recents, forKey: "recentStations")
    }
}
