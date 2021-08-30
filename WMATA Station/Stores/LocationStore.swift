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

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "LocationStore")
    private let locationManager: CLLocationManager

    override public init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        closestStations = []

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
        logger.debug("Getting Closest Stations to \(self.location?.description ?? "[no location]")")
    }
}
