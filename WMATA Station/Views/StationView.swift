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
    @EnvironmentObject var linesManager: LinesManager

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
                .font(.metroFont(.largeTitle).weight(.medium))
                .padding(.trailing, spacing * 2)
            Dots(lines: station.allConnections(to: nil).sorted())
            Spacer()
            WalkingTimeView(station: station, spacing: spacing)
                .font(.metroFont(.body).weight(.medium))
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

struct Dots: View {

    var lines: [Line]

    var body: some View {
        ForEach(lines, id: \.rawValue) {
            $0.dot(style: .largeTitle)
        }
    }
}

struct StationView_Previews: PreviewProvider {
    static var previews: some View {
        let locationManager = LocationManager()
        let linesManager = PreviewLinesManager() as LinesManager
        Group {
            StationView(station: .metroCenterUpper)
                .environmentObject(locationManager)
                .environmentObject(linesManager)
            StationView(station: .farragutWest)
                .environmentObject(locationManager)
                .environmentObject(linesManager)
        }
    }
}
