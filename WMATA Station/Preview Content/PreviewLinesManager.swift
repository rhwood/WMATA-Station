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

    override init() {
        super.init()
        stationInformations = PreviewData.preview.stationInformations
    }

    override func stations(for line: Line) {
        stations[line] = PreviewData.preview.stations
    }
}
