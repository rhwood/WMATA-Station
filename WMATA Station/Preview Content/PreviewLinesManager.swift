//
//  PreviewLocationStore.swift
//  WMATA Station
//
//  Created by Randall Wood on 8/29/21.
//

import Foundation
import WMATA
import WMATAUI

class PreviewLinesManager: LinesStore {

    override func getStations() {
        getStations(Array(PreviewData.preview.stationInformations.values))
    }
}
