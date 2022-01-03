//
//  PreviewLocationManager.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-11-28.
//

import CoreLocation
import Foundation
import WMATA

class PreviewLocationManager: LocationManager {

    init(_ defaultAuthorizationStatus: CLAuthorizationStatus) {
        super.init(manager: MockCLLocationManager(defaultAuthorizationStatus))
    }
    
    override func walkingTime(station: Station) -> TimeInterval {
        switch authorizationStatus {
        case .denied, .notDetermined, .restricted:
            return 0
        default:
            return 100
        }
    }

}

class MockCLLocationManager: CLLocationManager {

    private var dummyAuthorizationStatus: CLAuthorizationStatus

    public override var authorizationStatus: CLAuthorizationStatus {
        dummyAuthorizationStatus
    }

    init(_ defaultAuthorizationStatus: CLAuthorizationStatus) {
        dummyAuthorizationStatus = defaultAuthorizationStatus
    }

    override func requestWhenInUseAuthorization() {
        dummyAuthorizationStatus = .authorizedWhenInUse
    }

    override func requestLocation() {
        // do nothing
    }
}
