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

    let station: StationInformation
    let trains: MetroNextTrainsModel

    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .leading) {
                let spacing = UIFont.preferredFont(forTextStyle: .footnote).pointSize * 1 / 3
                TitleView(station: station.station, spacing: spacing)
                .font(WMATAUI.font(.largeTitle).weight(.medium))
                .padding()
                MetroRailPredictionsView(station: station.station, trains: trains)
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
                .padding(.trailing, spacing * 2)
            Dots(lines: station.lines.sorted(by: WMATAUI.mapOrder(_:_:)))
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
        Group {
            StationView(station: PreviewData.preview.stationInformations[.A01]!,
                        trains: MetroNextTrainsModel(station: PreviewData.preview.stationInformations[.A01]!,
                                                     preview: PreviewData.preview.railPredictions))
            StationView(station: PreviewData.preview.stationInformations[.E03]!,
                        trains: MetroNextTrainsModel(station: PreviewData.preview.stationInformations[.E03]!,
                                                     preview: PreviewData.preview.railPredictions))
        }
    }
}
