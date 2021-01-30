//
//  View+Extension.swift
//  WMATA Station
//
//  Created by Randall Wood on 2021-01-11.
//

import SwiftUI

extension View {

    func balance(width: Binding<CGFloat>, height: Binding<CGFloat>, alignment: Alignment = .center) -> some View {
        modifier(BalancedGetter(width: width, height: height, alignment: alignment))
    }

    func balance(height: Binding<CGFloat>, alignment: VerticalAlignment = .center) -> some View {
        modifier(BalancedHeightGetter(height: height, alignment: alignment))
    }

    func balance(width: Binding<CGFloat>, alignment: HorizontalAlignment = .center) -> some View {
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

struct BalancedGetter: ViewModifier {
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    var alignment: Alignment
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color
                        .clear
                        .frame(maxHeight: .infinity)
                        .onAppear {
                            if geo.size.height > height {
                                height = geo.size.height
                            }
                            if geo.size.width > width {
                                width = geo.size.width
                            }
                        }
                }
            )
            .if(height != .zero || width != .zero) {
                $0.frame(width: width, height: height, alignment: alignment)
            }
    }
}

struct BalancedHeightGetter: ViewModifier {
    @Binding var height: CGFloat
    var alignment: VerticalAlignment
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color
                        .clear
                        .frame(maxHeight: .infinity)
                        .onAppear {
                            if geo.size.height > height {
                                height = geo.size.height
                            }
                        }
                }
            )
            .if(height != .zero) {
                $0.frame(height: height, alignment: Alignment(horizontal: .center, vertical: alignment))
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
