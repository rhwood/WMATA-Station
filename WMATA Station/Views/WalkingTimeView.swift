//
//  WalkingTimeView.swift
//  WMATA Station
//
//  Created by Randall Wood on 8/28/21.
//

import SwiftUI
import CoreLocation
import MapKit
import WMATA

struct WalkingTimeView: View {

    var station: Station
    var spacing: CGFloat
    let formatter = DateComponentsFormatter()
    @EnvironmentObject var locationManager: LocationManager

    var body: some View {
        let walkingTime = walkingTime(station: station)
        if walkingTime > 0 {
            HStack(spacing: spacing) {
                Image(systemName: "figure.walk").imageScale(.small)
                Text(formatter.string(from: walkingTime)!)
            }
        } else {
            EmptyView()
        }
    }

    public init(station: Station, spacing: CGFloat) {
        self.station = station
        self.spacing = spacing
        formatter.unitsStyle = .short
        formatter.maximumUnitCount = 1
    }

    func walkingTime(station: Station) -> TimeInterval {
        switch locationManager.authorizationStatus {
        case .denied, .notDetermined, .restricted:
            return 0
        default:
            return 100
        }
    }
}

struct WalkingTimeView_Previews: PreviewProvider {
    static var previews: some View {
        WalkingTimeView(station: .metroCenterUpper, spacing: 10)
            .environmentObject(PreviewLocationManager(.authorizedWhenInUse) as LocationManager)
        WalkingTimeView(station: .metroCenterUpper, spacing: 10)
            .environmentObject(PreviewLocationManager(.notDetermined) as LocationManager)
        WalkingTimeView(station: .metroCenterUpper, spacing: 10)
            .environmentObject(PreviewLocationManager(.denied) as LocationManager)
    }
}
