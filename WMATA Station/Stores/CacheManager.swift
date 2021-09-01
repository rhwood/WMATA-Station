//
//  CacheManager.swift
//  WMATA Station
//
//  Created by Randall Wood on 8/28/21.
//

import Foundation
import WMATA

/// Store recently viewed stations without retaining history (like a recent documents list in a word processor).
class CacheManager: ObservableObject {

    let max = 10
    @Published private(set) var recentStations: [Station]

    init() {
        recentStations = []
        let recents = UserDefaults.standard.stringArray(forKey: "recentStations") ?? [String]()
        for id in recents.reversed() {
            if let station = Station.init(rawValue: id) {
                setMostRecentStation(station)
            }
        }
    }

    /// The most recently viewed station, nil if no station recently viewed
    var mostRecentStation: Station? {
        get {
            if recentStations.count != 0 {
                return recentStations[0]
            }
            return nil
        }
        set {
            if let station = newValue {
                setMostRecentStation(station)
            }
        }
    }

    /// Set the most recent station; this is a separate func because bindings are immutable?
    func setMostRecentStation(_ station: Station) {
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
