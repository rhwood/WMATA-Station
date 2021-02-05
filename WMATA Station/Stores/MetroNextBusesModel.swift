//
//  MetroNextBusesModel.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/29/21.
//

import Foundation
import WMATA

class MetroNextBusesModel: ObservableObject {

    @Published var stops: [Stop] = []
    @Published var buses: [Stop: [BusPrediction]] = [:]
    @Published var allBuses: [BusPrediction] = []
    var station: StationInformation
    private let interval: TimeInterval
    private var timer: Timer = Timer()
    private let metroBus = MetroBus(key: ApiKeys.wmata)

    init(station: StationInformation, preview: [Stop: [BusPrediction]]? = nil) {
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
        if stops.isEmpty {
            getStops()
        } else {
            for stop in stops {
                metroBus.nextBuses(for: stop) { [self] result in
                    switch result {
                    case .success(let predictions):
                        print("predictions for \(stop.id) are \(predictions)")
                        DispatchQueue.main.async {
                            buses[stop] = predictions.predictions
                        }
                        rePredict()
                    case .failure(let error):
                        print("\(error) requesting predictions for \(stop.id)")
                    }
                }
            }
        }
    }

    private func getStops() {
        let radius = RadiusAtCoordinates(radius: 500, latitude: station.latitude, longitude: station.longitude)
        metroBus.searchStops(at: radius) { [self] result in
            switch result {
            case .success(let stopsResult):
                print("searchStops for \(station.latitude):\(station.longitude) are \(stopsResult)")
                DispatchQueue.main.async {
                    for stop in stopsResult.stops {
                        if let stop = stop.stop {
                            stops.append(stop)
                        }
                    }
                }
            case .failure(let error):
                print("\(error) requesting searchStops for \(station.latitude):\(station.longitude)")
            }
        }
    }

    private func rePredict() {
        DispatchQueue.main.async { [self] in
            allBuses = []
            for stop in buses {
                allBuses.append(contentsOf: stop.value)
            }
        }
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
