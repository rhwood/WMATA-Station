//
//  NextTrainsModel.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/23/21.
//

import Foundation
import WMATA

class MetroNextTrainsModel: ObservableObject {

    @Published var trains: [Rail.NextTrains.Response.Prediction] = []
    let station: Station
    private let interval: TimeInterval
    private var timer: Timer = Timer()

    init(station: Rail.StationInformation.Response, prediction: [Rail.NextTrains.Response.Prediction]? = nil) {
        self.station = station.station
        if let nextTrains = prediction {
            interval = -1
            trains = nextTrains
        } else {
            // 10 is smallest update interval from WMATA
            interval = 10
        }
    }
    
    private func nextTrains() {
        DispatchQueue.main.async { [self] in
            Task {
                do {
                    self.trains = try await Rail.NextTrains(key: ApiKeys.wmata, stations: station.allTogether).request().get().trains
                } catch {
                    print("\(error) requesting next trains for \(station)")
                }
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
