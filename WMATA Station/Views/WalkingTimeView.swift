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
    @State private var walkingTime: TimeInterval = 0

    var body: some View {
        HStack(spacing: spacing) {
            if walkingTime > 0 {
                Image(systemName: "figure.walk").imageScale(.small)
                Text(formatter.string(from: walkingTime)!)
            } else {
                EmptyView()
            }
        }
        .onReceive(locationManager.$walkingTimes) { _ in
            walkingTime(station: station)
        }
        .onAppear {
            walkingTime(station: station)
        }
    }

    public init(station: Station, spacing: CGFloat) {
        self.station = station
        self.spacing = spacing
        formatter.unitsStyle = .short
        formatter.maximumUnitCount = 1
    }

    func walkingTime(station: Station) {
        walkingTime = locationManager.walkingTime(station: station)
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
