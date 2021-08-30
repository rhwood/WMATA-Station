//
//  StationView.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/23/21.
//

import SwiftUI
import WMATA
import WMATAUI

struct StationView: View {

    let station: Station
    @EnvironmentObject var linesManager: LinesStore

    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .leading) {
                let spacing = UIFont.preferredFont(forTextStyle: .footnote).pointSize * 1 / 3
                if let info = linesManager.stationInformations[station] {
                    let model = StationModel(info)
                    TitleView(station: station, spacing: spacing)
                        .padding()
                    HStack {
                        MetroRailPredictionsView(station: station, trains: model.metroNextTrains)
                    }
                } else {
                    Text("Error getting station information.")
                }
            }
        }
    }
}

struct TitleView: View {

    var station: Station
    var spacing: CGFloat

    var body: some View {
        HStack(spacing: spacing) {
            Text(station.name)
                .font(WMATAUI.font(.largeTitle).weight(.medium))
                .padding(.trailing, spacing * 2)
            Dots(lines: station.lines.sorted(by: WMATAUI.mapOrder(_:_:)))
            Spacer()
            WalkingTimeView(station: station, spacing: spacing)
                .font(WMATAUI.font(.body).weight(.medium))
        }
    }
}

struct MetroRailPredictionsView: View {

    var station: Station
    var trains: MetroNextTrainsModel

    var body: some View {
        HStack {
            NextTrainsView(station: station, trains: trains)
        }
    }
}

struct MetroBusPredictionsView: View {

    var station: Station
    var buses: MetroNextBusesModel

    var body: some View {
        HStack {
            NextBusesView(station: station, buses: buses)
        }
    }
}

struct Dots: View {

    var lines: [Line]

    var body: some View {
        ForEach(lines, id: \.rawValue) {
            #if os(tvOS)
            let style = UIFont.TextStyle.title1
            #else
            let style = UIFont.TextStyle.largeTitle
            #endif
            $0.dot(style: style)
        }
    }
}

struct StationView_Previews: PreviewProvider {
    static var previews: some View {
        let locationManager = LocationStore()
        let linesManager = PreviewLinesManager()
        Group {
            StationView(station: .A01)
                .environmentObject(locationManager)
                .environmentObject(linesManager)
            StationView(station: .C03)
                .environmentObject(locationManager)
                .environmentObject(linesManager)
        }
    }
}
