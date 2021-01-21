//
//  WMATA_StationApp.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-03.
//

import SwiftUI

@main
struct WMATAStationApp: App {

    var body: some Scene {
        WindowGroup {
            LinesView(lines: LinesStore())
        }
    }
}
