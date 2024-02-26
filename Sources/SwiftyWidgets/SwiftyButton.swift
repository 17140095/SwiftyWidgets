//
//  SwiftyButton.swift
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
                    Text(props.showOnlyIcon ? "" : title)
                } icon: {
                    props.icon
                        .fgStyle(props.getFgColor())
                        .scaledToFit()
                }
                .font(props.font)
                .labelStyle(SwiftyButtonLabelStyle(props: props))
            Spacer()
        }
        .padding(props.padding)
        .font(props.font)
        .contentShape(RoundedRectangle(cornerRadius: props.cornerRadius))
        .background(props.getBgColor())
        .clipShape(RoundedRectangle(cornerRadius: props.cornerRadius))
        .shadow(props: props.shadow)
        .overlay {
            RoundedRectangle(cornerRadius: props.cornerRadius)
                .stroke(props.border.color, lineWidth: props.border.width)
        }
    }
}

#if DEBUG
@available(iOS 15.0, *)
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            SwiftyButton(title: "filled",props: SwiftyButtonProps(icon: Image(systemName: "person"), style: .FILLED)) {
                print("Button pressed")
            }
            SwiftyButton(title: "filled",props: SwiftyButtonProps(icon: Image(systemName: "person"), iconPos: .RIGHT, style: .FILLED)) {
                print("Button pressed")
            }
            SwiftyButton(title: "filled",props: SwiftyButtonProps(icon: Image(systemName: "person"), iconPos: .TOP, showOnlyIcon: true, shadow: ShadowProps(), style: .FILLED)) {
                print("Button pressed")
            }
            .frame(width: 100)
            
            SwiftyButton(title: "filled",props: SwiftyButtonProps(icon: Image(systemName: "person"), iconPos: .BOTTOM,  style: .FILLED)) {
                print("Button pressed")
            }
            SwiftyButton(title: "OUTLINE",props: SwiftyButtonProps(cornerRadius: 10.0, icon: Image(systemName: "person"), iconPos: .TOP, showOnlyIcon: true, style: .FILLED , effect: .DEFAULT)) {
                print("Button pressed")
            }
            SwiftyButton(title: "OUTLINE",props: SwiftyButtonProps(cornerRadius: 10.0, icon: Image(systemName: "person"), iconPos: .TOP, showOnlyIcon: true, style: .OUTLINED, effect: .DEFAULT)) {
                print("Button pressed")
            }
            .frame(width: 100)
            
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
            SwiftyButton(title: "OUTLINE",props: SwiftyButtonProps(cornerRadius: 10.0, icon: Image(systemName: "person"), iconPos: .TOP, style: .OUTLINED, effect: .DEFAULT)) {
                print("Button pressed")
            }
        }
    }//scroll
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
    public var padding: EdgeInsets
    public var icon: Image?
    public var iconPos: SwiftyButtonIconPos
    public var iconSpacing: CGFloat
    public var showOnlyIcon: Bool
    public var shadow: ShadowProps?
    public var border: BorderProps
    public var style: SwiftyButtonStyle
    public var colors: SwiftyButtonColors
    public var effect: SwiftyButtonEffect
    
    public init(
        font: Font = AppConfig.Buttons.font,
        cornerRadius: CGFloat = AppConfig.Buttons.radius,
        padding: EdgeInsets = AppConfig.Buttons.padding,
        icon: Image? = nil,
        iconPos: SwiftyButtonIconPos = .LEFT,
        iconSpacing: CGFloat = 5.0,
        showOnlyIcon: Bool = false,
        shadow: ShadowProps? = nil,
        border: BorderProps = AppConfig.Buttons.borderProps,
        style: SwiftyButtonStyle = AppConfig.Buttons.style,
        colors: SwiftyButtonColors = SwiftyButtonColors(),
        effect: SwiftyButtonEffect = AppConfig.Buttons.effect
    ) {
        self.font = font
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.icon = icon
        self.iconPos = iconPos
        self.iconSpacing = iconSpacing
        self.colors = colors
        self.showOnlyIcon = showOnlyIcon
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
}

@available(iOS 13.0, *)
public struct SwiftyButtonColors {
    public var filledFg: Color
    public var filledBg: Color
    public var outlinedFg: Color
    public var outlinedBg: Color
    
    public init(filledFg: Color = AppConfig.Buttons.filledFgColor, filledBg: Color = AppConfig.Buttons.filledBgColor, outlinedFg: Color = AppConfig.Buttons.outlinedFgColor, outlinedBg: Color = AppConfig.Buttons.outlinedBgColor) {
        
        self.filledFg = filledFg
        self.filledBg = filledBg
        self.outlinedFg = outlinedFg
        self.outlinedBg = outlinedBg
    }
    
    public func forBackground(_ style: SwiftyButtonStyle) -> Color {
        style == .FILLED ? self.filledBg : self.outlinedBg
    }
    public func forForeground(_ style: SwiftyButtonStyle) -> Color {
        style == .FILLED ? self.filledFg : self.outlinedFg
    }
    public func forBorder(_ style: SwiftyButtonStyle) -> Color {
        style == .FILLED ? self.filledBg : self.outlinedFg
    }
}

@available(iOS 13.0, *)
public struct BorderProps {
    public var color: Color
    public var width: CGFloat
    
    public init(color: Color = AppConfig.primaryColor, width: CGFloat = 1.0) {
        self.color = color
        self.width = width
    }
    
    public func getFocusWidth() -> CGFloat {
        self.width + 1.0
    }
}

@available(iOS 13.0, *)
public struct ShadowProps {
    public var color: Color
    public var radius: CGFloat
    public var x: CGFloat
    public var y: CGFloat
    
    public init(color: Color = AppConfig.shadowColor, radius: CGFloat = 5.0, x: CGFloat = 5.0, y: CGFloat = 5.0) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

public enum SwiftyButtonStyle{
    case FILLED, OUTLINED
}
public enum SwiftyButtonIconPos {
    case LEFT, RIGHT, TOP, BOTTOM
}

@available(iOS 15.0, *)
public struct SwiftyButtonLabelStyle: LabelStyle {
    
    private var props: SwiftyButtonProps
    private var spacing = 0.0
    
    public init(props: SwiftyButtonProps) {
        self.props = props
        self.spacing = props.showOnlyIcon ? 0.0 : props.iconSpacing
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        if props.showOnlyIcon {
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
