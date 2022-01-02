//
//  WMATA_StationApp.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-03.
//

import SwiftUI

@main
struct WMATAStationApp: App {

    let locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            LinesView()
                .environmentObject(LinesManager.standard)
                .environmentObject(locationManager)
                .environmentObject(CacheManager.standard)
        }
    }
}
