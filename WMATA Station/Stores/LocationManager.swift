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
public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var closestStations: [Station]
    @Published var currentLocation: CLLocation?
    @Published var stationLocations: [Station: CLLocation]

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "LocationStore")
    private let locationManager: CLLocationManager

    public init(manager: CLLocationManager = CLLocationManager()) {
        locationManager = manager
        authorizationStatus = locationManager.authorizationStatus
        closestStations = []
        stationLocations = [:]

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
        currentLocation = locations.last
        getClosestStations()
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.info("LocationManager failed: \(error.localizedDescription)")
    }

    func getClosestStations() {
        if let location = currentLocation {
            stationLocations = Dictionary(uniqueKeysWithValues: LinesManager.standard.stationInformations.map {
                ($0, CLLocation(latitude: $1.latitude, longitude: $1.longitude))
            })
            stationLocations
                .map { ($0, location.distance(from: $1)) }
                .filter {
                    switch $0.0 {
                    case .fortTottenLower, .lenfantPlazaLower, .galleryPlaceLower, .metroCenterLower:
                        return false
                    default:
                        return true
                    }
                }
                .sorted(by: { $0.1 < $1.1 })
                .prefix(CacheManager.standard.maxStations)
                .forEach { closestStations.append($0.0) }
        }
    }
}
