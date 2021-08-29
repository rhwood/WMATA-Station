//
//  LocationStore.swift
//  WMATA Station
//
//  Created by Randall Wood on 8/28/21.
//

import Foundation
import CoreLocation
import WMATA

/// Store the current location and determine shortest walking distance to any given station
public class LocationStore: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var closestStations: [Station]

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
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

}
