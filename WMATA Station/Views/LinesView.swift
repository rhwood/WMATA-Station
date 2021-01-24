//
//  ContentView.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-03.
//

import SwiftUI
import WMATA

struct LinesView: View {

    @State var roundelWidth: CGFloat = 0
    @State var roundelHeight: CGFloat = 0
    @ObservedObject var lines: LinesStore

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(alignment: .leading) {
                    LineView(line: nil,
                             view: AnyView(Image(systemName: "location")
                                            .roundel(color: MetroStationColor.lightBrown,
                                                     textColor: .white,
                                                     width: $roundelWidth,
                                                     height: $roundelHeight)),
                             stations: [.A01, .A02, .A03])
                    ForEach(WMATAUI.lines, id: \.rawValue) { line in
                        LineView(line: line,
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
}

struct LineView: View {

    var line: Line?
    var view: AnyView
    var stations: [Station]

    var body: some View {
        HStack(alignment: .center) {
            view
            ScrollView(.horizontal, showsIndicators: true) {
                StationSigns(line: line, stations: stations)
            }
        }
    }
}

struct StationSigns: View {

    var line: Line?
    var stations: [Station]

    var body: some View {
        LazyHStack {
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

    var body: some View {
        NavigationLink(
            destination: StationView(station: station, trains: NextTrainsModel(station: station)),
            label: {
                let footnoteSize = UIFont.preferredFont(forTextStyle: .footnote).pointSize
                VStack(alignment: .leading, spacing: footnoteSize * 0.25) {
                    Text(station.name)
                        .font(WMATAUI.font(.title3).weight(.medium))
                    HStack(spacing: footnoteSize * 0.25) {
                        ForEach(station.lines.sorted(by: WMATAUI.order(_:_:)), id: \.rawValue) {
                            $0.dot(style: .footnote)
                        }
                        Spacer()
                        Image(systemName: "figure.walk").imageScale(.small)
                        Text("Time")
                    }.font(WMATAUI.font(.body))
                }
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LinesView(lines: LinesStore(preview: true))
    }
}
