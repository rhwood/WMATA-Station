//
//  StationView.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/23/21.
//

import SwiftUI
import WMATA

struct StationView: View {

    let station: Station
    let trains: NextTrainsModel

    var body: some View {
        VStack(alignment: .leading) {
            let spacingUnit = UIFont.preferredFont(forTextStyle: .footnote).pointSize * 1 / 3
            HStack(spacing: spacingUnit) {
                Text(station.name)
                    .padding(.trailing, spacingUnit * 2)
                Dots(lines: station.lines.sorted(by: WMATAUI.order(_:_:)))
            }
            .font(WMATAUI.font(.largeTitle).weight(.medium))
            .padding()
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
            StationView(station: .A01, trains: NextTrainsModel(station: .A01, preview: PreviewData.railPredictions))
            StationView(station: .E03, trains: NextTrainsModel(station: .E03, preview: PreviewData.railPredictions))
        }
    }
}
