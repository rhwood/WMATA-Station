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
    @ObservedObject var lines: LinesStore
    @StateObject var locationStore = LocationStore()

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        if locationStore.authorizationStatus != .denied
                            && locationStore.authorizationStatus != .restricted {
                            lineView(line: nil,
                                     roundel: AnyView(Image(systemName: "location")
                                                        .roundel(color: MetroStationColor.lightBrown,
                                                                 textColor: .white,
                                                                 width: $roundelWidth,
                                                                 height: $roundelHeight)),
                                     views: [noLocationView()],
                                     stations: locationStore.closestStations)
                        }
                    ForEach(WMATAUI.lines, id: \.rawValue) { line in
                        lineView(line: line,
                                 roundel: AnyView(Text(line.rawValue)
                                                    .roundel(line: line,
                                                             width: $roundelWidth,
                                                             height: $roundelHeight)),
                                 views: [],
                                 stations: lines.stations[line]?.sorted(by: {$0.name < $1.name}) ?? [])
                    }
                }
                .font(WMATAUI.font(.largeTitle).weight(.medium))
            }
        }
    }

    func noLocationView() -> AnyView {
        switch locationStore.authorizationStatus {
        case .notDetermined:
            return AnyView(Button(action: {
                locationStore.requestPermission()
            }, label: {
                VStack(alignment: .leading, spacing: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.25) {
                    Text("Find Closest Station").font(WMATAUI.font(.title3).weight(.medium))
                    Text("And show walking time").font(WMATAUI.font(.body))
                }
            }))
        case .authorizedWhenInUse:
            if locationStore.closestStations.isEmpty {
                return AnyView(ProgressView())
            } else {
                return AnyView(EmptyView())
            }
        default:
            return AnyView(EmptyView())
        }
    }

    func locationRoundel() -> AnyView {
        AnyView(Image(systemName: "location")
                    .roundel(color: MetroStationColor.lightBrown,
                             textColor: .white,
                             width: $roundelWidth,
                             height: $roundelHeight))
    }

    func lineView(line: Line?, roundel: AnyView, views: [AnyView], stations: [Station]) -> some View {
        HStack(alignment: .center) {
            roundel
            ScrollView(.horizontal, showsIndicators: true) {
                stationSigns(line: line, stations: stations, views: views)
            }
        }
    }

    func stationSigns(line: Line?, stations: [Station], views: [AnyView]) -> some View {
        LazyHStack(alignment: .top) {
            ForEach(0..<views.count) { (index) in
                views[index]
            }
            ForEach(stations, id: \.rawValue) {
                stationSign(line: line, station: $0)
            }
        }
        .padding()
    }

    func stationSign(line: Line?, station: Station) -> some View {
        let spacing = UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.25
        if let info = lines.stationInformations[station] {
            return AnyView(NavigationLink(
                            destination: StationView(station: StationModel(info)),
                            label: {
                                VStack(alignment: .leading, spacing: spacing) {
                                    Text(station.name).font(WMATAUI.font(.title3).weight(.medium))
                                    footer(station: station, spacing: spacing)
                                }
                            }))
        } else {
            return AnyView(Button(
                            action: { /* only shown when navigation link cannot be created, so no action */ },
                            label: {
                                Text(station.name).font(WMATAUI.font(.title3).weight(.medium))
                            }))
        }
    }

    func footer(station: Station, spacing: CGFloat) -> some View {
        HStack(spacing: spacing) {
            ForEach(station.lines.sorted(by: WMATAUI.mapOrder(_:_:)), id: \.rawValue) {
                $0.dot(style: .footnote)
            }
            Spacer()
            if locationStore.authorizationStatus == .authorizedWhenInUse {
                WalkingTimeView(station: station, spacing: spacing)
            }
        }.font(WMATAUI.font(.body))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LinesView(lines: LinesStore(preview: true))
    }
}
