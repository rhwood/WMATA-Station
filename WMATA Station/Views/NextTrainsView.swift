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
        let spacing = UIFont.preferredFont(forTextStyle: .headline).pointSize
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
                Text(train.destinationName).frame(alignment: .leading)
                Text(train.minutes.description).frame(alignment: .trailing)
            }
        }.font(.metroFont(.headline).bold())
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
