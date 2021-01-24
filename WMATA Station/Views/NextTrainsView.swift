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

    init(station: Station, trains: NextTrainsModel) {
        self.station = station
        self.trains = trains
        self.trains.start()
    }

    var body: some View {
        let columns = [
            GridItem(.flexible(), alignment: .leading),
            GridItem(.flexible(), alignment: .center),
            GridItem(.flexible(), alignment: .leading),
            GridItem(.flexible(), alignment: .trailing)
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
                let cars = Text(train.car ?? "-")
                if train.car == "8" {
                    cars
                } else {
                    cars.foregroundColor(.red)
                }
                Text(train.destinationName).frame(alignment: .leading)
                Text(train.minutes).frame(alignment: .trailing)
            }
        }.font(WMATAUI.font(.headline).bold())
    }
}

struct NextTrains_Previews: PreviewProvider {
    static var previews: some View {
        NextTrainsView(station: .A01, trains: NextTrainsModel(stations: [.A01], preview: PreviewData.railPredictions))
    }
}
