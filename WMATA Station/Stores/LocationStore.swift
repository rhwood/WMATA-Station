//
//  LocationStore.swift
//  WMATA Station
//
//  Created by Randall Wood on 8/28/21.
//

import Foundation
import CoreLocation
import WMATA
import os

/// Store the current location and determine shortest walking distance to any given station
public class LocationStore: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var closestStations: [Station]
    @Published var location: CLLocation?
    @Published var distances: [Station: CLLocationDistance]

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "LocationStore")
    private let locationManager: CLLocationManager

    public init(manager: CLLocationManager = CLLocationManager()) {
        locationManager = manager
        authorizationStatus = locationManager.authorizationStatus
        closestStations = []
        distances = [:]

        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        #if !os(tvOS)
        locationManager.startUpdatingLocation()
        #endif
        locationManagerDidChangeAuthorization(locationManager)
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        getClosestStations()
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.info("LocationManager failed: \(error.localizedDescription)")
    }

    func getClosestStations() {
        if let currentLocation = location {
            distances = Dictionary(uniqueKeysWithValues: LinesStore.standard.stationInformations.map { key, value in
                return (key, currentLocation
                            .distance(from: CLLocation(latitude: value.latitude, longitude: value.longitude)))
            })
            for distance in distances.sorted(by: { return $0.value.magnitude < $1.value.magnitude })
                    .prefix(CacheManager.standard.maxStations) {
                closestStations.append(distance.key)
            }
        }
    }
}
