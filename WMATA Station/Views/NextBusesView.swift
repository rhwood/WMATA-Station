//
//  NextTrains.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/23/21.
//

import SwiftUI
import WMATA
import WMATAUI

struct NextBusesView: View {

    var station: Station
    @ObservedObject var buses: MetroNextBusesModel
    @State var roundelWidth: CGFloat = 0
    @State var roundelHeight: CGFloat = 0

    var body: some View {
        let spacing = UIFont.preferredFont(forTextStyle: .headline).pointSize
        let columns = [
            GridItem(spacing: spacing),
            GridItem(spacing: spacing, alignment: .leading),
            GridItem(alignment: .trailing)
        ]
        LazyVGrid(columns: columns) {
            Text("Route")
            Text("Destination")
            Text("Minutes")
            ForEach(buses.allBuses) { bus in
                Text(bus.route.description)
                    .font(.metroFont(.subheadline).bold())
                Text(bus.directionText).frame(alignment: .leading)
                Text(bus.minutes.description).frame(alignment: .trailing)
            }
        }.font(.metroFont(.headline).bold())
        .onAppear {
            buses.start()
        }
        .onDisappear {
            buses.stop()
        }
    }
}

struct NextBusesView_Previews: PreviewProvider {
    static var previews: some View {
        NextBusesView(station: .metroCenterUpper,
                      buses: MetroNextBusesModel(station: PreviewData.preview.stationInformations[.metroCenterUpper]!,
                                                    preview: nil))
    }
}
