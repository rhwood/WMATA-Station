//
//  PreviewLocationManager.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-11-28.
//

import Foundation
import CoreLocation

class PreviewLocationManager: LocationStore {
    
    init(_ defaultAuthorizationStatus: CLAuthorizationStatus) {
        super.init(manager: MockCLLocationManager(defaultAuthorizationStatus))
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
