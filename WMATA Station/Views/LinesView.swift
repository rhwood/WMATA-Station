//
//  ContentView.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-03.
//

import SwiftUI
import CoreLocation
import WMATA
import WMATAUI

struct LinesView: View {

    @State var roundelWidth: CGFloat = 0
    @State var roundelHeight: CGFloat = 0
    @EnvironmentObject var lines: LinesManager
    @EnvironmentObject var locationStore: LocationManager
    @EnvironmentObject var cacheManager: CacheManager

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(alignment: .leading) {
                        switch locationStore.authorizationStatus {
                        case .notDetermined:
                            LineView(line: nil,
                                     roundel: nonRouteRoundel(systemName: "location"),
                                     leading: AnyView(Button(action: {
                                        locationStore.requestPermission()
                                     }, label: {
                                        VStack(
                                            alignment: .leading,
                                            spacing: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.25) {
                                                Text("Find Closest Stations").font(.metroFont(.title3).weight(.medium))
                                                Text("And show walking time").font(.metroFont(.body))
                                        }
                                     })),
                                     stations: [])
                        case .authorizedWhenInUse:
                            if locationStore.closestStations.isEmpty {
                                EmptyView()
                            } else {
                                LineView(line: nil,
                                         roundel: nonRouteRoundel(systemName: "location"),
                                         stations: locationStore.closestStations)
                            }
                        default:
                            EmptyView()
                        }
                        if cacheManager.mostRecentStation != nil {
                            LineView(line: nil,
                                     roundel: nonRouteRoundel(systemName: "clock"),
                                     stations: cacheManager.recentStations)
                        }
                    ForEach(Line.allCurrent.sorted(), id: \.rawValue) { line in
                        LineView(line: line,
                                 roundel: line.roundel(style: .largeTitle, factor: 2.0) as! AnyView,
                                 stations: lines.stations[line]?.sorted(by: {$0.name < $1.name}) ?? [])
                    }
                }
                .font(.metroFont(.largeTitle).weight(.medium))
            }
        }
    }

    func nonRouteRoundel(systemName: String) -> AnyView {
        AnyView(ZStack {
            WMATAUI.dot(color: .metroStationLightBrown, style: .largeTitle, factor: 2.0)
            Image(systemName: systemName)
                    .font(.metroFont(.largeTitle).bold())
        })
    }
}

struct LineView: View {

    var line: Line?
    var roundel: AnyView
    var leading: AnyView = AnyView(EmptyView())
    var stations: [Station]

    var body: some View {
        HStack(alignment: .center) {
            roundel
            ScrollView(.horizontal, showsIndicators: true) {
                StationSigns(line: line, stations: stations, leading: leading)
            }
        }
    }
}

struct StationSigns: View {

    var line: Line?
    var stations: [Station]
    var leading: AnyView

    var body: some View {
        LazyHStack(alignment: .top) {
            leading
            ForEach(stations, id: \.rawValue) {
                StationSign(line: line, station: $0)
            }
        }
        .padding()
    }
}

struct StationSign: View {

    var line: Line?
    var station: Station
    @EnvironmentObject var linesManager: LinesManager
    @EnvironmentObject var cacheManager: CacheManager

    var body: some View {
        let spacing = UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.25
        NavigationLink(
            destination: StationView(station: station)
                .environmentObject(linesManager)
                .onAppear {
                    cacheManager.setMostRecentStation(station)
                },
            label: {
                VStack(alignment: .leading, spacing: spacing) {
                    Text(station.name).font(.metroFont(.title3).weight(.medium))
                    StationSignFooter(station: station, spacing: spacing)
                }
            })
    }
}

struct StationSignFooter: View {

    var station: Station
    var spacing: CGFloat

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(station.allConnections(to: nil).sorted(), id: \.rawValue) {
                $0.dot(style: .footnote)
            }
            Spacer()
            WalkingTimeView(station: station, spacing: spacing)
        }.font(.metroFont(.body))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var linesManager = PreviewLinesManager() as LinesManager
    static var previews: some View {
        LinesView()
            .environmentObject(linesManager)
            .environmentObject(CacheManager())
            .environmentObject(PreviewLocationManager(.authorizedWhenInUse) as LocationManager)
        LinesView()
            .environmentObject(linesManager)
            .environmentObject(CacheManager())
            .environmentObject(PreviewLocationManager(.notDetermined) as LocationManager)
        LinesView()
            .environmentObject(linesManager)
            .environmentObject(CacheManager())
            .environmentObject(PreviewLocationManager(.denied) as LocationManager)
    }
}
