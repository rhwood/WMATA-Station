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
                Text(train.line.rawValue).roundel(line: train.line, width: $roundelWidth, height: $roundelHeight)
                Text(train.car ?? "-")
                Text(train.destinationName).frame(alignment: .leading)
                Text(train.minutes).frame(alignment: .trailing)
            }
        }.font(WMATAUI.font(.headline))
    }
}

struct NextTrains_Previews: PreviewProvider {
    static let data = [RailPrediction(car: "8",
                                      destination: "Wiehle",
                                      destinationCode: .N06,
                                      destinationName: Station.N06.name,
                                      group: "2",
                                      line: .SV,
                                      location: .A01,
                                      locationName: Station.A01.name,
                                      minutes: "BRD"),
                       RailPrediction(car: "8",
                                      destination: "Wiehle",
                                      destinationCode: .N06,
                                      destinationName: Station.N06.name,
                                      group: "2",
                                      line: .SV,
                                      location: .A01,
                                      locationName: Station.A01.name,
                                      minutes: ""),
                       RailPrediction(car: "8",
                                      destination: "Wiehle",
                                      destinationCode: .N06,
                                      destinationName: Station.N06.name,
                                      group: "2",
                                      line: .SV,
                                      location: .A01,
                                      locationName: Station.A01.name,
                                      minutes: "12")]
    static var previews: some View {
        NextTrainsView(station: .A01, trains: NextTrainsModel(stations: [.A01], preview: data))
    }
}
