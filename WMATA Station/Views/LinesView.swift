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
    @EnvironmentObject var lines: LinesStore
    @EnvironmentObject var locationStore: LocationStore
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
                                            Text("Find Closest Stations").font(WMATAUI.font(.title3).weight(.medium))
                                            Text("And show walking time").font(WMATAUI.font(.body))
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
                    ForEach(WMATAUI.lines, id: \.rawValue) { line in
                        LineView(line: line,
                                 roundel: AnyView(Text(line.rawValue)
                                                    .bold()
                                                    .padding()
                                                    .roundel(line: line,
                                                             width: $roundelWidth,
                                                             height: $roundelHeight)),
                                 stations: lines.stations[line]?.sorted(by: {$0.name < $1.name}) ?? [])
                    }
                }
                .font(WMATAUI.font(.largeTitle).weight(.medium))
            }
        }
    }

    func nonRouteRoundel(systemName: String) -> AnyView {
        AnyView(Image(systemName: systemName)
                    .font(WMATAUI.font(.largeTitle).bold())
                    .padding()
                    .roundel(color: MetroStationColor.lightBrown,
                             textColor: .white,
                             width: $roundelWidth,
                             height: $roundelHeight))
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
    @EnvironmentObject var linesManager: LinesStore
    @EnvironmentObject var cacheManager: CacheManager

    var body: some View {
        let spacing = UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.25
        NavigationLink(
            destination: StationView(station: station)
                .environmentObject(linesManager)
                .onAppear {
                    // should be // cacheManager.mostRecentStation = station // but EnvironmentObjects are immutable
                    cacheManager.setMostRecentStation(station)
                },
            label: {
                VStack(alignment: .leading, spacing: spacing) {
                    Text(station.name).font(WMATAUI.font(.title3).weight(.medium))
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
            ForEach(station.lines.sorted(by: WMATAUI.mapOrder(_:_:)), id: \.rawValue) {
                $0.dot(style: .footnote)
            }
            Spacer()
            WalkingTimeView(station: station, spacing: spacing)
        }.font(WMATAUI.font(.body))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LinesView()
            .environmentObject(PreviewLinesManager())
            .environmentObject(CacheManager())
            .environmentObject(LocationStore())
            .environmentObject(LinesStore())
    }
}
