//
//  WMATA_StationApp.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-03.
//

import SwiftUI

@main
struct WMATAStationApp: App {

    let linesManager = LinesStore()
    let locationManager = LocationStore()
    let recentStationsManager = RecentsStore()

    var body: some Scene {
        WindowGroup {
            LinesView()
                .environmentObject(linesManager)
                .environmentObject(locationManager)
                .environmentObject(recentStationsManager)
        }
    }
}
