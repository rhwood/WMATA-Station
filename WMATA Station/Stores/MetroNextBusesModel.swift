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
    @Published var buses: [Stop: [Bus.NextBuses.Response.Prediction]] = [:]
    @Published var allBuses: [Bus.NextBuses.Response.Prediction] = []
    var station: Rail.StationInformation.Response
    private let interval: TimeInterval
    private var timer: Timer = Timer()

    init(station: Rail.StationInformation.Response, preview: [Stop: [Bus.NextBuses.Response.Prediction]]? = nil) {
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
                DispatchQueue.main.async {
                    Task {
                        do {
                            self.buses[stop] = try await Bus.NextBuses(key: ApiKeys.wmata, stop: stop).request().get().predictions
                        } catch {
                            print("\(error) getting predictions for \(stop)")
                        }
                    }
                }
            }
        }
    }

    private func getStops() {
        let radius = WMATALocation(radius: 500, latitude: station.latitude, longitude: station.longitude)
        DispatchQueue.main.async {
            Task {
                do {
                    self.stops = try await Bus.StopsSearch(key: ApiKeys.wmata, location: radius).request().get().stops.compactMap({ $0.stop })
                } catch {
                    print ("\(error) requesting stops within 500m of \(self.station)")
                }
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
