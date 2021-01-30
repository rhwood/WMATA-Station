//
//  MetroNextBusesModel.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/29/21.
//

import Foundation
import WMATA

class MetroNextBusesModel: ObservableObject {

    @Published var buses: [BusPrediction] = []
}
