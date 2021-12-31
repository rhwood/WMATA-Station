//
//  NextTrainsModel.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/23/21.
//

import Foundation
import WMATA

class MetroNextTrainsModel: JSONEndpointDelegate<Rail.NextTrains>, ObservableObject {

    @Published var trains: [Rail.NextTrains.Response.Prediction] = []
    let station: Station
    private let interval: TimeInterval
    private var timer: Timer = Timer()

    init(station: Rail.StationInformation.Response, prediction: [Rail.NextTrains.Response.Prediction]? = nil) {
        self.station = station.station
        if let next = prediction {
            interval = -1
            trains = next
        } else {
            // 10 is smallest update interval from WMATA
            interval = 10
        }
    }

    private func nextTrains() {
        Rail.NextTrains(key: ApiKeys.wmata, stations: station.allTogether, delegate: nil).request { result in
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
