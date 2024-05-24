//
//  Extensions.swift
//  PodTest
//
//  Created by Ali Raza on 01/02/2024.
//

import Foundation
import SwiftUI

extension String {
    public var isNotEmpty: Bool {
        !self.isEmpty
    }
    public var trim: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public var isBlank: Bool {
        self.trim.isEmpty
    }
}
extension Bundle {
    public func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
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
    @ViewBuilder public func border(props: BorderProps?) -> some View {
        if let props = props {
            self.border(props.color, width: props.width)
        } else {
            self
        }
    }
    @ViewBuilder public func border(props: BorderProps, isFocus: Bool, isError: Bool, if condition: Bool) -> some View {
        if condition {
            self.border(isError ? .red : props.color, width: isFocus ? props.getFocusWidth() : props.width )
        } else {
            self
        }
    }
    
    
    @ViewBuilder public func textFieldStyle<S>(style: S, if condition: Bool) -> some View where S : TextFieldStyle {
        if condition {
            self.textFieldStyle(style)
        } else {
            self
        }
    }
    @ViewBuilder public func padding(_ insets: EdgeInsets, if condition: Bool) -> some View {
        if condition {
            self.padding(insets)
        } else {
            self
        }
    }
    @ViewBuilder public func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil, if condition: Bool) -> some View {
        if condition {
            self.padding(edges, length)
        } else {
            self
        }
    }
    
    @ViewBuilder public func shadow(props: ShadowProps?) -> some View {
        if let props = props {
            self.shadow(color: props.color, radius: props.radius, x: props.x, y: props.y)
        } else {
            self
        }
    }
    
    
    @ViewBuilder public func background<S>(_ style: Color, if condition: Bool = true) -> some View where S : ShapeStyle {
        self.background(condition ? style : .clear )
    }
    
    @ViewBuilder public func fgStyle(_ style: Color) -> some View{
        if #available(iOS 15.0, *) {
            self.foregroundStyle(style)
        } else {
            self.foregroundColor(style)
        }
    }
    
    @ViewBuilder public func tintColor(_ color: Color) -> some View {
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
    
    @ViewBuilder public func tintColor(_ color: Color, if condition: Bool) -> some View {
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
    
    @ViewBuilder public func buttonStyle<S>(_ style: S, if condition: Bool) -> some View where S : ButtonStyle {
        if condition {
            self.buttonStyle(style)
        } else {
            self
        }
    }
    
    @ViewBuilder public func onChangeInput(of value: String, delegate inputDelegate: SwiftyInputProtocol?, perform action: @escaping (_ newValue: String) -> Void) -> some View {
        
        if #available(iOS 17.0, *) {
            self.onChange(of: value) { oldValue, newValue in
                action(newValue)
                inputDelegate?.onChange(newValue)
            }
        } else {
            self.onChange(of: value, perform: { newValue in
                action(newValue)
                inputDelegate?.onChange(newValue)
            })
        }
    }
    
    @ViewBuilder public func onChangeFocus(of value: Bool, delegate inputDelegate: SwiftyInputProtocol?, perform action: @escaping (_ newValue: Bool) -> Void) -> some View {
        
        if #available(iOS 17.0, *) {
            self.onChange(of: value) { oldFocusValue, focusValue in
                action(focusValue)
                inputDelegate?.onFocus(focusValue)
            }
        } else {
            self.onChange(of: value, perform: { focusValue in
                action(focusValue)
                inputDelegate?.onFocus(focusValue)
            })
        }
    }
    
    @ViewBuilder public func overlay<V>(alignment: Alignment = .center, if condition: Bool, @ViewBuilder content: () -> V) -> some View where V : View {
        if condition {
            self.overlay(alignment: alignment, content: content)
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
    func customBackButton(title: String = "", onPress: (()-> Void)? = nil, showBtn: Bool = true) -> some View {
        modifier(CustomBackButton(title: title,onPress: onPress, showBtn: showBtn))
    }
    @ViewBuilder func border<S>(_ content: S, width: CGFloat = 1, if condition: Bool) -> some View where S : ShapeStyle {
        if condition {
            self.border(content, width: width)
        } else {
            self
        }
    }
    @ViewBuilder func background<S>(_ style: S, ignoresSafeAreaEdges edges: Edge.Set = .all, if condition: Bool) -> some View where S : ShapeStyle {
        if condition {
            self.background(style, ignoresSafeAreaEdges: edges)
        } else {
            self
        }
    }
    
    @ViewBuilder public func swiftyAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryAction: (name: String, perform: (()-> Void)) = ("OK", {}),
        secondaryAction: (name: String, perform: (()-> Void)) = ("", {}),
        props: SwiftyAlertProps = SwiftyAlertProps()
    )-> some View {
        if isPresented.wrappedValue {
            ZStack {
                self // Original content
                    .disabled(isPresented.wrappedValue)
                    .blur(radius: isPresented.wrappedValue ? 3 : 0)
                SwiftyAlert(isPresented: isPresented, title: title, message: message, props: props, primaryAction: primaryAction, secondaryAction: secondaryAction)
            }
            
        } else {
            self
        }
    }
    
}
