//
//  ContentView.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-03.
//

import SwiftUI
import WMATA
import WMATAUI

struct LinesView: View {

    @State var roundelWidth: CGFloat = 0
    @State var roundelHeight: CGFloat = 0
    @ObservedObject var lines: LinesStore

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(alignment: .leading) {
                    lineView(line: nil,
                             view: AnyView(Image(systemName: "location")
                                            .roundel(color: MetroStationColor.lightBrown,
                                                     textColor: .white,
                                                     width: $roundelWidth,
                                                     height: $roundelHeight)),
                             stations: [.A01, .A02, .A03])
                    ForEach(WMATAUI.lines, id: \.rawValue) { line in
                        lineView(line: line,
                                 view: AnyView(Text(line.rawValue)
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

    func lineView(line: Line?, view: AnyView, stations: [Station]) -> some View {
        HStack(alignment: .center) {
            view
            ScrollView(.horizontal, showsIndicators: true) {
                stationSigns(line: line, stations: stations)
            }
        }
    }

    func stationSigns(line: Line?, stations: [Station]) -> some View {
        LazyHStack(alignment: .top) {
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
            Image(systemName: "figure.walk").imageScale(.small)
            Text("Time")
        }.font(WMATAUI.font(.body))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LinesView(lines: LinesStore(preview: true))
    }
}
