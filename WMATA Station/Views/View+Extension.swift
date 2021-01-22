//
//  View+Extension.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-11.
//

import SwiftUI

extension View {

    func balanceWidth(store width: Binding<CGFloat>, alignment: HorizontalAlignment = .center) -> some View {
        modifier(BalancedWidthGetter(width: width, alignment: alignment))
    }

    @ViewBuilder func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct BalancedWidthGetter: ViewModifier {
    @Binding var width: CGFloat
    var alignment: HorizontalAlignment
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color
                        .clear
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            if geo.size.width > width {
                                width = geo.size.width
                            }
                        }
                }
            )
            .if(width != .zero) {
                $0.frame(width: width, alignment: Alignment(horizontal: alignment, vertical: .center))
            }
    }
}
