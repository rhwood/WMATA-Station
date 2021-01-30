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
    var station: StationInformation
    private let interval: TimeInterval
    private var timer: Timer = Timer()
    private let metroBus = MetroBus(key: ApiKeys.wmata)

    init(station: StationInformation, preview: [BusPrediction]? = nil) {
        self.station = station
        if preview == nil {
            // 10 is smallest update interval from WMATA
            interval = 10
        } else {
            interval = -1
            buses = preview!
        }
    }

    private func nextBuses() {
//        metroRail.nextTrains(at: station.allTogether) { result in
//            switch result {
//            case .success(let railPreditions):
//                print("nextTrains for \(String(describing: self.station.allTogether)) are \(railPreditions)")
//                DispatchQueue.main.async {
//                    self.trains = railPreditions.trains
//                }
//            case .failure(let error):
//                print("\(error) requesting nextTrains for \(String(describing: self.station.allTogether))")
//            }
//        }
    }

    func start() {
        if interval > 0 {
            print("Starting nextbus polling for \(String(describing: station.station))")
            nextBuses()
            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                self.nextBuses()
            }
        }
    }

    func stop() {
        timer.invalidate()
    }
}
