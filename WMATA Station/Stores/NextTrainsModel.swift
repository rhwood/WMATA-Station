//
//  NextTrainsModel.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/23/21.
//

import Foundation
import WMATA

class NextTrainsModel: ObservableObject {

    @Published var trains: [RailPrediction] = []
    let station: Station
    private let interval: TimeInterval
    private var timer: Timer = Timer()
    private let metroRail = MetroRail(key: ApiKeys.wmata)

    init(station: Station, preview: [RailPrediction]? = nil) {
        self.station = station
        if preview == nil {
            interval = 15
        } else {
            interval = -1
            trains = preview!
        }
    }

    private func nextTrains() {
        metroRail.nextTrains(at: station.allTogether) { result in
            switch result {
            case .success(let railPreditions):
                print("nextTrains for \(String(describing: self.station.allTogether)) are \(railPreditions)")
                DispatchQueue.main.async {
                    self.trains = railPreditions.trains
                }
            case .failure(let error):
                print("\(error) requesting nextTrains for \(String(describing: self.station.allTogether))")
            }
        }
    }

    func start() {
        if interval > 0 {
            print("Starting nexttrain polling for \(String(describing: station.allTogether))")
            nextTrains()
            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                self.nextTrains()
            }
        }
    }

    func stop() {
        timer.invalidate()
    }
}
