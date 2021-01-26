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
    @State var lineWidth: CGFloat = 0
    @State var carsWidth: CGFloat = 0
    @State var destWidth: CGFloat = 0
    @State var minsWidth: CGFloat = 0

    var body: some View {
        LazyVStack {
            HStack {
                Text("Line").balanceWidth(store: $lineWidth)
                Text("Cars").balanceWidth(store: $carsWidth)
                Text("Destination").balanceWidth(store: $destWidth, alignment: .leading)
                Text("Minutes").balanceWidth(store: $minsWidth, alignment: .trailing)
            }
            ForEach(trains.trains) { train in
                HStack {
                    Text(train.line.rawValue)
                        .font(WMATAUI.font(.subheadline).bold())
                        .roundel(line: train.line, width: $roundelWidth, height: $roundelHeight)
                        .padding()
                        .balanceWidth(store: $lineWidth)
                    let cars = Text(train.car ?? "").balanceWidth(store: $carsWidth)
                    if train.car == "8" {
                        cars
                    } else {
                        cars.foregroundColor(.red)
                    }
                    Text(train.destinationName).frame(alignment: .leading).balanceWidth(store: $destWidth, alignment: .leading)
                    Text(train.minutes).frame(alignment: .trailing).balanceWidth(store: $minsWidth, alignment: .trailing)
                }
            }
        }.font(WMATAUI.font(.headline).bold())
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
