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
    let stations: [Station]
    private let interval: TimeInterval
    private var timer: Timer = Timer()

    init(stations: [Station], preview: [RailPrediction]? = nil) {
        self.stations = stations
        if preview == nil {
            interval = 15
        } else {
            interval = -1
            trains = preview!
        }
    }

    private func nextTrains() {
        self.stations.first?.nextTrains(withApiKey: ApiKeys.wmata) { result in
            print("requested nextTrains for \(String(describing: self.stations.first))")
            switch result {
            case .success(let railPreditions):
                print("\(railPreditions)")
                DispatchQueue.main.async {
                    self.trains = railPreditions.trains
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }

    func start() {
        if interval > 0 {
            print("Starting nexttrain polling for \(String(describing: stations.first))")
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
