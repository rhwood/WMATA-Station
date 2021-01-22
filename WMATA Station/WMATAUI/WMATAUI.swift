//
//  WMATAUI.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-07.
//

import SwiftUI
import WMATA

struct WMATAUI {

    /// Metro Brown (Pantone 448 CVC)
    static let brown = Color(.sRGB, red: 74 / 256, green: 65 / 256, blue: 42 / 256, opacity: 1)
    /// Metro Light Brown (Pantone Warm Gray 10 C)
    static let lightBrown = Color(.sRGB, red: 121 / 256, green: 110 / 256, blue: 101 / 256, opacity: 1)
    /// Pantone 661
    static let secondaryBlue = Color(.sRGB, red: 0, green: 53 / 256, blue: 148 / 256, opacity: 1)

    /// Active lines in system map order
    static let lines: [Line] = [.RD, .OR, .BL, .GR, .YL, .SV]

    /// The WMATA standard font with the given style
    static func font(_ style: Font.TextStyle) -> Font {
        Font.custom("Helvetica Neue",
                    size: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.with(textStyle: style)).pointSize,
                    relativeTo: style)
    }

}
