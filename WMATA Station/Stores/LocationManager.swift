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
import MapKit

/// Store the current location and determine shortest walking distance to any given station
public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var closestStations: [Station] = []
    @Published var currentLocation: CLLocation?
    @Published var stationLocations: [Station: CLLocation] = [:]
    @Published var walkingTimes: [Station: TimeInterval] = [:]

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "LocationManager")
    private let locationManager: CLLocationManager

    public init(manager: CLLocationManager = CLLocationManager()) {
        locationManager = manager
        authorizationStatus = locationManager.authorizationStatus

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
        walkingTimes = [:]
        getClosestStations()
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.info("Failed handling location: \(error.localizedDescription)")
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
    
    func walkingTime(station: Station) -> TimeInterval {
        switch authorizationStatus {
        case .denied, .notDetermined, .restricted:
            return 0
        default:
            if let walkingTime = walkingTimes[station] {
                return walkingTime
            } else if let stationLocation = stationLocations[station], let currentLocation = currentLocation {
                let request = MKDirections.Request()
                request.transportType = .walking
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: stationLocation.coordinate))
                Task { () -> TimeInterval in
                    do {
                        let walkingTime = try await MKDirections(request: request).calculate().routes[0].expectedTravelTime
                        DispatchQueue.main.async {
                            self.walkingTimes[station] = walkingTime
                        }
                        return walkingTime
                    } catch {
                        logger.error("Failed getting walking time to \(station.rawValue): \(error.localizedDescription)")
                        return 0
                    }
                }
            }
        }
        return 0
    }
}
