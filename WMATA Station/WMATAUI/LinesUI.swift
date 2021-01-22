//
//  Line.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-06.
//

import SwiftUI
import WMATA

extension Line {

    /// colors from
    /// https://www.wmata.com/business/procurement/solicitations/documents/Metro_Brand_and_Style_Guidelines.pdf
    var backgroundColor: Color {
        switch self {
        case .RD:
            return Color(.sRGB, red: 191 / 256, green: 13 / 256, blue: 62 / 256)
        case .OR:
            return Color(.sRGB, red: 237 / 256, green: 139 / 256, blue: 0)
        case .BL:
            return Color(.sRGB, red: 0, green: 156 / 256, blue: 222 / 256)
        case .GR:
            return Color(.sRGB, red: 0, green: 177 / 256, blue: 64 / 256)
        case .YL, .YLRP:
            return Color(.sRGB, red: 255 / 256, green: 209 / 256, blue: 0)
        case .SV:
            return Color(.sRGB, red: 145 / 256, green: 157 / 256, blue: 157 / 256)
        }
    }

    var textColor: Color {
        switch self {
        case .RD, .BL, .GR:
            return Color.white
        case .OR, .SV, .YL, .YLRP:
            return Color.black
        }
    }
}
