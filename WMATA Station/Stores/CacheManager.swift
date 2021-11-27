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

    /// Recently viewed stations
    @Published private(set) var recentStations: [Station] = []
    /// Maximum number of stations returned in an ordered query (other then stations on a line)
    @Published private(set) var maxStations = 5
    /// Seconds to retain cached (to user defaults) information before forcing a requery
    private var cacheDuration = 86400

    static public var standard = CacheManager()

    init() {
        if UserDefaults.standard.object(forKey: "maxResults") != nil {
            setMaxStations(UserDefaults.standard.integer(forKey: "maxResults"), setDefaults: false)
        } else {
            setMaxStations(maxStations)
        }
        if UserDefaults.standard.object(forKey: "cacheDuration") != nil {
            setCacheDuration(UserDefaults.standard.integer(forKey: "cacheDuration"), setDefaults: false)
        } else {
            setCacheDuration(cacheDuration)
        }
        let recents = UserDefaults.standard.stringArray(forKey: "recentStations") ?? []
        for id in recents {
            if let station = Station.init(rawValue: id) {
                setMostRecentStation(station, setDefaults: false)
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
    func setMostRecentStation(_ station: Station, setDefaults: Bool = true) {
        // copy so there is only one redraw, not (potentially) multiple
        var recents = recentStations
        // remove any matching entries in recents list
        recents.removeAll(where: { station == $0 })
        // prepend station to recents list
        recents.insert(station, at: 0)
        // truncate recents list to max items
        while recents.count > maxStations {
            recents.remove(at: maxStations)
        }
        // save recents list to UserDefaults
        if (setDefaults) {
            UserDefaults.standard.set(recents.map { $0.rawValue }, forKey: "recentStations")
        }
        // update recentStations and allow redraws
        recentStations = recents
    }

    /// Set the maximum number of stations returned in an ordered query (other than stations on a line)
    func setMaxStations(_ max: Int, setDefaults: Bool = true) {
        maxStations = max
        if (setDefaults) {
            UserDefaults.standard.set(maxStations, forKey: "maxResults")
        }
    }

    /// Set the number of seconds to retain cached data before clearing it
    func setCacheDuration(_ duration: Int, setDefaults: Bool = true) {
        cacheDuration = duration
        if (setDefaults) {
            UserDefaults.standard.set(cacheDuration, forKey: "cacheDuration")
        }
    }

    func cache(name key: String, object value: Any) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.set(Date(), forKey: "\(key)CacheDate")
    }

    func retrieve(name key: String) -> Any? {
        if let cached = UserDefaults.standard.object(forKey: "\(key)CacheDate") as? Date, cached.addingTimeInterval(TimeInterval(cacheDuration)) > Date() {
            return UserDefaults.standard.object(forKey: key)
        }
        return nil
    }
}
