//
//  NextTrains.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/23/21.
//

import SwiftUI
import WMATA
import WMATAUI

struct NextTrainsView: View {

    var station: Station
    @ObservedObject var trains: MetroNextTrainsModel
    @State var roundelWidth: CGFloat = 0
    @State var roundelHeight: CGFloat = 0

    var body: some View {
        let style = Font.TextStyle.title3
        let spacing = WMATAUIFont.preferredFont(forTextStyle: .with(textStyle: style)).pointSize
        let columns = [
            GridItem(spacing: spacing),
            GridItem(spacing: spacing),
            GridItem(spacing: spacing, alignment: .leading),
            GridItem(alignment: .trailing)
        ]
        LazyVGrid(columns: columns) {
            Text("Line")
            Text("Cars")
            Text("Destination")
            Text("Minutes")
            ForEach(trains.trains) { train in
                if let line = train.line {
                Text(line.rawValue)
                    .font(.metroFont(.subheadline).bold())
                    .roundel(line: line, width: $roundelWidth, height: $roundelHeight)
                }
                let cars = Text("\(train.car?.rawValue ?? "")" )
                if train.car == .eight {
                    cars
                } else {
                    cars.foregroundColor(.red)
                }
                Text(train.destination?.name ?? train.destinationName).frame(alignment: .leading).lineLimit(1)
                Text(train.minutes.description).frame(alignment: .trailing)
            }
        }.font(.metroFont(style).weight(.bold))
        .onAppear {
            trains.start()
        }
        .onDisappear {
            trains.stop()
        }
    }
}

struct NextTrains_Previews: PreviewProvider {
    static var previews: some View {
        NextTrainsView(station: .metroCenterUpper,
                       trains: MetroNextTrainsModel(station: PreviewData.preview.stationInformations[.metroCenterUpper]!,
                                                    prediction: PreviewData.preview.railPredictions))
    }
}
