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
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                    Image(systemName:  "location")
                        .roundel(backgroundColor: WMATAUI.lightBrown, foregroundColor: .white, balanceWidth: $roundelWidth)
                    ScrollView(.horizontal, showsIndicators: true) {
                        LazyHStack {
                            ForEach(1...5, id: \.self) {
                                StationSign(name: "Item \($0)")
                            }
                        }
                        .padding()
                    }
                }
                ForEach(WMATAUI.lines, id:\.rawValue) {
                    let line = $0
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                        Text(line.rawValue)
                            .roundel(backgroundColor: line.backgroundColor, foregroundColor: line.textColor, balanceWidth: $roundelWidth)
                        ScrollView(.horizontal, showsIndicators: true) {
                            LazyHStack {
                                ForEach(lines.stations[line]?.sorted(by: {$0.name < $1.name}) ?? [], id:\.rawValue) {
                                    StationSign(name: "\($0.name)")
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
    }
    
    func showStation(_ station: Any) -> Void {
        // eventually show a stationView
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

struct StationSign: View {
    
    var name: String

    var body: some View {
        Button(name, action: {})
            .font(WMATAUI.font(.title3).weight(.medium))
    }
}

extension View {

    func roundel(backgroundColor: Color, foregroundColor: Color, balanceWidth: Binding<CGFloat>) -> some View {
        modifier(Roundel(backgroundColor: backgroundColor, foregroundColor: foregroundColor, balanceWidth: balanceWidth))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LinesView(lines: LinesStore(preview: true))
    }
}
