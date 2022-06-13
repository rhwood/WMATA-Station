//
//  Roundel.swift
//  WMATA Station
//
//  Created by Randall Wood on 2022-01-02.
//

import SwiftUI
import WMATA
import WMATAUI

struct Roundel_Preview: PreviewProvider {
    static var previews: some View {
        let style = Font.TextStyle.largeTitle
        VStack {
            ForEach(Line.allCases, id: \.rawValue) { line in
                HStack {
                    line.roundel(style: style)
                    Text(line.name)
                        .font(.metroFont(style))
                }
            }
        }
    }
}
