//
//  NextTrains.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/23/21.
//

import SwiftUI
import WMATA

struct NextTrainsView: View {

    var station: Station
    @ObservedObject var trains: NextTrainsModel
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
            ForEach(trains.trains, id: \.id) { train in
                Text(train.line.rawValue)
                    .font(WMATAUI.font(.subheadline).bold())
                    .roundel(line: train.line, width: $roundelWidth, height: $roundelHeight)
                let cars = Text(train.car ?? "")
                if train.car == "8" {
                    cars
                } else {
                    cars.foregroundColor(.red)
                }
                Text(train.destinationName).frame(alignment: .leading)
                Text(train.minutes).frame(alignment: .trailing)
            }
        }
        .font(WMATAUI.font(.headline).bold())
        .onAppear() {
            trains.start()
        }
        .onDisappear() {
            trains.stop()
        }
    }
}

struct NextTrains_Previews: PreviewProvider {
    static var previews: some View {
        NextTrainsView(station: .A01, trains: NextTrainsModel(station: .A01, preview: PreviewData.railPredictions))
    }
}
