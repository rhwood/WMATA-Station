//
//  Roundel.swift
//  WMATA Station
//
//  Created by Randall Wood on 1/23/21.
//

import SwiftUI
import WMATA

extension View {

    func roundel(line: Line, width: Binding<CGFloat>, height: Binding<CGFloat>) -> some View {
        roundel(color: line.color, textColor: line.textColor, width: width, height: height)
    }

    func roundel(color: Color, textColor: Color, width: Binding<CGFloat>, height: Binding<CGFloat>) -> some View {
        modifier(Roundel(color: color, textColor: textColor, width: width, height: height))
    }
}

struct Roundel: ViewModifier {

    let color: Color
    let textColor: Color
    @Binding var width: CGFloat
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content
            .foregroundColor(textColor)
            .padding()
            .background(Circle().foregroundColor(color))
            .balance(width: $width, height: $height)
    }
}
