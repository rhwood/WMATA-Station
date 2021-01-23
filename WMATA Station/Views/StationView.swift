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

    var body: some View {
        VStack {
            HStack(spacing: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.33) {
                Text(station.name)
                    .font(WMATAUI.font(.largeTitle).weight(.medium))
                ForEach(station.lines.sorted(by: WMATAUI.order(_:_:)), id: \.rawValue) {
                    #if os(tvOS)
                    let style = UIFont.TextStyle.title1
                    #else
                    let style = UIFont.TextStyle.largeTitle
                    #endif
                    $0.dot(style: style)
                }
            }.padding()
        }
    }
}

struct StationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StationView(station: .A01)
            StationView(station: .N06)
        }
    }
}
