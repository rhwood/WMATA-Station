//
//  RecentsStore.swift
//  WMATA Station
//
//  Created by Randall Wood on 8/28/21.
//

import Foundation
import WMATA

/// Store recently viewed stations without retaining history (like a recent documents list in a word processor).
class RecentsStore: ObservableObject {

    let max = 10
    @Published var recentStations: [Station]

    init() {
        recentStations = []
        let recents = UserDefaults.standard.stringArray(forKey: "recentStations") ?? [String]()
        for id in recents {
            // protect against having same station multiple times in UserDefaults (should
            // not happen but did during development), load only max number of recent
            // stations, and ensure value in recentStations is a known station
            if let station = Station.init(rawValue: id),
               !recentStations.contains(station) && recentStations.count <= max {
                recentStations.append(station)
            }
        }
    }

    /// Get the last station viewed by the user
    var lastStation: Station? {
        if recentStations.count != 0 {
            return recentStations[0]
        }
        return nil
    }

    /// Add a station to the recents store, if the station already exists in the recents store
    /// it gets moved to the beginning
    func addStation(station: Station) {
        // copy so there is only one redraw, not (potentially) multiple
        var recents = recentStations
        // remove any matching entries in recents list
        recents.removeAll(where: { station == $0 })
        // prepend station to recents list
        recents.insert(station, at: 0)
        // truncate recents list to max items
        while recents.count > max {
            recents.remove(at: max)
        }
        // save recents list to UserDefaults
        UserDefaults.standard.set(recents.map { $0.rawValue }, forKey: "recentStations")
        // update recentStations and allow redraws
        recentStations = recents
    }
}
