//
//  Extensions.swift
//  PodTest
//
//  Created by Ali Raza on 01/02/2024.
//

import Foundation
import SwiftUI

extension String {
    public func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIColor {
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

@available(iOS 13.0, *)
extension Color {
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func uiColor() -> UIColor {

        if #available(iOS 14.0, *) {
            return UIColor(self)
        }

        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
    public func overlaying<V: View>(_ view: V) -> some View {
        return view.overlay(self)
    }
}

@available(iOS 15.0, *)
extension View {
    
    public func keyboardAwarePadding() -> some View {
        ModifiedContent(
            content: self,
            modifier: KeyboardHeightModifier()
        )
    }
    @ViewBuilder
    public func border(props: BorderProps, if condition: Bool) -> some View {
        if condition {
            self.border(props.color, width: props.width)
        } else {
            self
        }
    }
    @ViewBuilder
    public func border<S>(_ content: S, width: CGFloat = 1, if condition: Bool) -> some View where S : ShapeStyle {
        if condition {
           self.border(content, width: width)
        } else {
            self
        }
    }
    
    @ViewBuilder
    public func textFieldStyle<S>(style: S, if condition: Bool) -> some View where S : TextFieldStyle {
        if condition {
            self.textFieldStyle(style)
        } else {
            self
        }
    }
    
    @ViewBuilder
    public func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil, if condition: Bool) -> some View {
        if condition {
            self.padding(edges, length)
        } else {
            self
        }
    }
    
    @ViewBuilder
    public func shadow(props: ShadowProps, if condition: Bool = true) -> some View {
        if condition, props.apply {
            self.shadow(color: props.color, radius: props.radius, x: props.x, y: props.y)
        } else {
            self
        }
    }
    
    
    @ViewBuilder
    public func background<S>(_ style: Color, if condition: Bool = true) -> some View where S : ShapeStyle {
        self.background(condition ? style : .clear )
    }
    
    @ViewBuilder
    public func focused(_ condition: Binding<Bool>) -> some View {
        
    }
    
    @ViewBuilder
    public func fgStyle(_ style: Color) -> some View{
        if #available(iOS 15.0, *) {
            self.foregroundStyle(style)
        } else {
            self.foregroundColor(style)
        }
    }
    
    @ViewBuilder
    public func tintColor(_ color: Color) -> some View {
        if #available(iOS 16.0, *) {
            self.tint(color)
        } else {
            self.overlay(
                color
                    .mask(self)
                    .foregroundColor(color)
            )
        }
    }
    
    @ViewBuilder
    public func tintColor(_ color: Color, if condition: Bool) -> some View {
        if condition {
            if #available(iOS 16.0, *) {
                self.tint(color)
            } else {
                self.overlay(
                    color
                        .mask(self)
                        .foregroundColor(color)
                )
            }
        } else {
            self
        }
        
    }
    public func showLoading(isLoading: Binding<Bool>) -> some View {
            ZStack {
                self // Original content
                    .disabled(isLoading.wrappedValue)
                    .blur(radius: isLoading.wrappedValue ? 3 : 0)

                if isLoading.wrappedValue {
                    LoadingViews.getInstance().getLoader()
                }
            }
        }
}
