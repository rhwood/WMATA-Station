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

    /// Active lines in the order listed on the [2019 System Map](https://wmata.com/schedules/maps/upload/2019-System-Map.pdf).
    static let lines: [Line] = [.RD, .OR, .BL, .GR, .YL, .SV]

    /// All lines in the order listed on the [2019 System Map](https://wmata.com/schedules/maps/upload/2019-System-Map.pdf).
    /// This includes the Yellow Rush Plus (YLRP, ran from 2012 to 2017) line after Yellow (YL).
    static let allLines: [Line] = [.RD, .OR, .BL, .GR, .YL, .YLRP, .SV]

    /// The WMATA standard font with the given style.
    ///
    /// - Parameter style: The font style.
    ///
    /// - Returns: The WMATA standard font in the given style.
    static func font(_ style: Font.TextStyle) -> Font {
        Font.custom("Helvetica Neue",
                    size: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.with(textStyle: style)).pointSize,
                    relativeTo: style)
    }

    /// Order lines in the order used by WMATA for line designations in stations.
    /// The order used is the order lines are listed on the [2019 System Map](https://wmata.com/schedules/maps/upload/2019-System-Map.pdf).
    ///
    /// - Parameter line0: The first line.
    /// - Parameter line1: The second line.
    ///
    /// - Returns: true if line0 is before line1 in the order on the map; false otherwise.
    static func order(_ line0: Line, _ line1: Line) -> Bool {
        return allLines.firstIndex(of: line0) ?? 0 < allLines.firstIndex(of: line1) ?? 0
    }
}
