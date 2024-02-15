//
//  AppButton.swift
//  HealthDiet
//
//  Created by Ali Raza on 21/01/2024.
//

import SwiftUI

@available(iOS 15.0, *)
public struct SwiftyButton: View {
    public let title: String
    public var props: SwiftyButtonProps = SwiftyButtonProps()
    public let onPress: ()-> Void
    
    public init(title: String, props: SwiftyButtonProps = SwiftyButtonProps(), onPress: @escaping () -> Void) {
        self.title = title
        self.props = props
        self.onPress = onPress
    }
    
    public var body: some View {
        Button(action: {
            onPress()
        }) {
            buildFilledOutlineView()
        }
        .fgStyle(props.getFgColor())
        
        .buttonStyle(ScaleEffectStyle(props: self.props), if: props.effect == .SCALER)
    }
    
    @ViewBuilder
    private func buildFilledOutlineView() -> some View {
       
        HStack(spacing: 0) {
            Spacer()
                Label {
                    Text(props.isImageOnly() ? "" : title)
                } icon: {
                    props.icon
                        .fgStyle(props.getFgColor())
                        .scaledToFit()
                }
                .font(props.font)
                .labelStyle(VerticalLabelStyle(props: props))
            Spacer()
        }
        .padding(.vertical, props.paddingV)
        .padding(.horizontal, props.paddingH)
        .font(props.font)
        .shadow(props: props.shadow)
        .contentShape(RoundedRectangle(cornerRadius: props.cornerRadius))
        .background(props.getBgColor())
        .clipShape(RoundedRectangle(cornerRadius: props.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: props.cornerRadius)
                .stroke(props.border.color, lineWidth: props.border.width)
        }
    }
}

#if DEBUG
@available(iOS 15.0, *)
#Preview {
    VStack(spacing: 10) {
        SwiftyButton(title: "filled",props: SwiftyButtonProps(icon: Image(systemName: "person"), style: .FILLED)) {
            print("Button pressed")
        }
        SwiftyButton(title: "filled",props: SwiftyButtonProps(icon: Image(systemName: "person"), iconPos: .RIGHT, style: .FILLED)) {
            print("Button pressed")
        }
        SwiftyButton(title: "filled",props: SwiftyButtonProps(icon: Image(systemName: "person"), iconPos: .TOP,  style: .FILLED)) {
            print("Button pressed")
        }
        SwiftyButton(title: "filled",props: SwiftyButtonProps(icon: Image(systemName: "person"), iconPos: .BOTTOM,  style: .FILLED)) {
            print("Button pressed")
        }
        SwiftyButton(title: "OUTLINE",props: SwiftyButtonProps(cornerRadius: 10.0, icon: Image(systemName: "person"), iconPos: .TOP, style: .IMAGE_ONLY_FILLED)) {
            print("Button pressed")
        }
        
        SwiftyButton(title: "OUTLINE",props: SwiftyButtonProps(icon: Image(systemName: "person"), iconPos: .LEFT, iconSpacing: 5, style: .OUTLINED)) {
            print("Button pressed")
        }
        SwiftyButton(title: "OUTLINE",props: SwiftyButtonProps(icon: Image(systemName: "person"), iconPos: .RIGHT, iconSpacing: 5, style: .OUTLINED)) {
            print("Button pressed")
        }
        SwiftyButton(title: "OUTLINE",props: SwiftyButtonProps(icon: Image(systemName: "person"), iconPos: .TOP, iconSpacing: 5, style: .OUTLINED)) {
            print("Button pressed")
        }
        SwiftyButton(title: "OUTLINE",props: SwiftyButtonProps(icon: Image(systemName: "person"), iconPos: .BOTTOM, iconSpacing: 5, style: .OUTLINED)) {
            print("Button pressed")
        }
        SwiftyButton(title: "OUTLINE",props: SwiftyButtonProps(cornerRadius: 10.0, icon: Image(systemName: "person"), iconPos: .TOP, style: .IMAGE_ONLY_OUTLINED)) {
            print("Button pressed")
        }
    }
}

#endif

@available(iOS 15.0.0, *)
fileprivate struct ScaleEffectStyle: ButtonStyle {

    private var props: SwiftyButtonProps
    
    public init(props: SwiftyButtonProps) {
        self.props = props
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(props.getFgColor())
            .font(props.font)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

public enum SwiftyButtonEffect {
    case DEFAULT, SCALER
}

@available(iOS 15.0, *)
public struct SwiftyButtonProps {
    public var font: Font
    public var cornerRadius: CGFloat
    public var paddingV: CGFloat
    public var paddingH: CGFloat
    public var icon: Image?
    public var iconPos: SwiftyButtonIconPos
    public var iconSpacing: CGFloat
    public var showIcon: Bool
    public var shadow: ShadowProps
    public var border: BorderProps
    public var style: SwiftyButtonStyle
    public var colors: SwiftyButtonColors
    public var effect: SwiftyButtonEffect
    
    public init(font: Font = ThemeFonts.SwiftyButton.font, cornerRadius: CGFloat = 10.0, paddingV: CGFloat = 15.0, paddingH: CGFloat = 15.0, icon: Image? = nil, iconPos: SwiftyButtonIconPos = .LEFT, iconSpacing: CGFloat = 5.0, showIcon: Bool = true, shadow: ShadowProps = ShadowProps(), border: BorderProps = BorderProps(color: ThemeColors.SwiftyButton.filledFg), style: SwiftyButtonStyle = .FILLED, colors: SwiftyButtonColors = SwiftyButtonColors(), effect: SwiftyButtonEffect = .SCALER) {
        self.font = font
        self.cornerRadius = cornerRadius
        self.paddingV = paddingV
        self.paddingH = paddingH
        self.icon = icon
        self.iconPos = iconPos
        self.iconSpacing = iconSpacing
        self.colors = colors
        self.showIcon = showIcon
        self.shadow = shadow
        self.border = border
        self.style = style
        self.border.color = colors.forBorder(style)
        self.effect = effect
    }
    
    public func getBgColor() -> Color {
        self.colors.forBackground(self.style)
    }
    public func getFgColor() -> Color {
        self.colors.forForeground(self.style)
    }
    public func getBorderColor() -> Color {
        self.colors.forBorder(self.style)
    }
    public func isImageOnly() -> Bool {
        style == .IMAGE_ONLY_FILLED || style == .IMAGE_ONLY_OUTLINED
    }
}

@available(iOS 13.0, *)
public struct SwiftyButtonColors {
    public var filledFg: Color
    public var filledBg: Color
    public var outlinedFg: Color
    public var outlinedBg: Color
    
    public init(filledFg: Color = ThemeColors.SwiftyButton.filledFg, filledBg: Color = ThemeColors.SwiftyButton.filledBg, outlinedFg: Color = ThemeColors.SwiftyButton.outlinedFg, outlinedBg: Color = ThemeColors.SwiftyButton.outlinedBg) {
        
        self.filledFg = filledFg
        self.filledBg = filledBg
        self.outlinedFg = outlinedFg
        self.outlinedBg = outlinedBg
    }
    
    public func forBackground(_ style: SwiftyButtonStyle) -> Color {
        (style == .FILLED || style == .IMAGE_ONLY_FILLED) ? self.filledBg : self.outlinedBg
    }
    public func forForeground(_ style: SwiftyButtonStyle) -> Color {
        (style == .FILLED || style == .IMAGE_ONLY_FILLED) ? self.filledFg : self.outlinedFg
    }
    public func forBorder(_ style: SwiftyButtonStyle) -> Color {
        (style == .FILLED || style == .IMAGE_ONLY_FILLED)  ? self.filledBg : self.outlinedFg
    }
}

@available(iOS 13.0, *)
public struct BorderProps {
    public var color: Color = ThemeColors.primary
    public var width: CGFloat = 2.0
    
    public init(color: Color = ThemeColors.primary, width: CGFloat = 2.0) {
        self.color = color
        self.width = width
    }
}

@available(iOS 13.0, *)
public struct ShadowProps {
    public var color: Color = ThemeColors.primary .opacity(0.33)
    public var radius: CGFloat = 5.0
    public var x: CGFloat = 5.0
    public var y: CGFloat = 5.0
    public var apply: Bool = true
    
    public init(color: Color = ThemeColors.primary.opacity(0.33), radius: CGFloat = 5.0, x: CGFloat = 5.0, y: CGFloat = 5.0, apply: Bool = true) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
        self.apply = apply
    }
}

public enum SwiftyButtonStyle{
    case FILLED, OUTLINED, IMAGE_ONLY_FILLED, IMAGE_ONLY_OUTLINED
}
public enum SwiftyButtonIconPos {
    case LEFT, RIGHT, TOP, BOTTOM
}

@available(iOS 15.0, *)
public struct VerticalLabelStyle: LabelStyle {
    
    private var props: SwiftyButtonProps
    private var spacing = 0.0
    
    public init(props: SwiftyButtonProps) {
        self.props = props
        self.spacing = props.isImageOnly() ? 0.0 : props.iconSpacing
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        if props.isImageOnly() {
            configuration.icon
        } else {
            getView(configuration: configuration)
        }
    }
    
    @ViewBuilder 
    private func getView(configuration: Configuration) -> some View {
        switch props.iconPos {
        case .LEFT:
            HStack(spacing: spacing){
                configuration.icon
                configuration.title
            }
        case .RIGHT:
            HStack(spacing: spacing) {
                configuration.title
                configuration.icon
            }
        case .TOP:
            VStack(spacing: spacing) {
                configuration.icon
                configuration.title
            }
        case .BOTTOM:
            VStack(spacing: spacing) {
                configuration.title
                configuration.icon
            }
        }
    }
}
