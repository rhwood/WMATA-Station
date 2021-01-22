//
//  ContentView.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-03.
//

import SwiftUI
import WMATA

struct LinesView: View {

    @State var roundelWidth: CGFloat = 0
    @ObservedObject var lines: LinesStore

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(alignment: .leading) {
                LineView(line: AnyView(Image(systemName: "location")
                            .roundel(backgroundColor: WMATAUI.lightBrown,
                                     foregroundColor: .white,
                                     balanceWidth: $roundelWidth)),
                         stations: [.A01, .A02, .A03])
                ForEach(WMATAUI.lines, id: \.rawValue) {
                    let line = $0
                    LineView(line: AnyView(Text(line.rawValue)
                                .roundel(backgroundColor: line.backgroundColor,
                                         foregroundColor: line.textColor,
                                         balanceWidth: $roundelWidth)),
                             stations: lines.stations[line]?.sorted(by: {$0.name < $1.name}) ?? [])
                }
            }
        }
    }

    func showStation(_ station: Any) {
        // eventually show a stationView
    }
}

struct LineView: View {

    var line: AnyView
    var stations: [Station]

    var body: some View {
        HStack(alignment: .center) {
            line
            ScrollView(.horizontal, showsIndicators: true) {
                StationSigns(stations: stations)
            }
        }
    }
}

struct Roundel: ViewModifier {

    let backgroundColor: Color
    let foregroundColor: Color
    @Binding var balanceWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .font(WMATAUI.font(.title).weight(.medium))
            .foregroundColor(foregroundColor)
            .padding()
            .background(Circle().foregroundColor(backgroundColor))
            .balanceWidth(store: $balanceWidth)
    }
}

struct StationSigns: View {

    var stations: [Station]

    var body: some View {
        LazyHStack {
            ForEach(stations, id: \.rawValue) {
                StationSign(name: "\($0.name)")
            }
        }
        .padding()
    }
}

struct StationSign: View {

    var name: String

    var body: some View {
        Button(name, action: {
            // need to trigger StationView, but until that is built, there is nothing to do
        })
        .font(WMATAUI.font(.title3).weight(.medium))
    }
}

extension View {

    func roundel(backgroundColor: Color, foregroundColor: Color, balanceWidth: Binding<CGFloat>) -> some View {
        modifier(Roundel(backgroundColor: backgroundColor,
                         foregroundColor: foregroundColor,
                         balanceWidth: balanceWidth))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LinesView(lines: LinesStore(preview: true))
    }
}
