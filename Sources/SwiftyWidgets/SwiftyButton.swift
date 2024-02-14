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
            buildView(iconPos: props.iconPos)
        }
    }
    
    @ViewBuilder
    private func buildView( iconPos: SwiftyButtonIconPos = .LEFT) -> some View {
       
        VStack(spacing: 0) {
            if props.showIcon, iconPos == .TOP {
                props.icon
                    .tintColor(props.getIconColor())
            }
            HStack {
                Spacer()
                if props.showIcon, iconPos == .LEFT {
                    props.icon
                        .tintColor(props.getIconColor())
                }
                if props.style != .IMAGE_ONLY {
                    Text(title)
                        .tintColor(props.getFgColor())
                        .padding(getIconSpaceEdge(), props.iconSpacing)
                }
                if props.showIcon, iconPos == .RIGHT {
                    props.icon
                        .tintColor(props.getIconColor())
                }
                Spacer()
            }
            if props.showIcon, iconPos == .BOTTOM {
                props.icon
                    .tintColor(props.getIconColor())
            }
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
    
    private func getIconSpaceEdge() -> Edge.Set {
        var edge: Edge.Set = .leading
        
        if props.iconPos == .LEFT {
            edge = .leading
        } else if props.iconPos == .TOP {
            edge = .top
        } else if props.iconPos == .RIGHT {
            edge = .trailing
        } else {
            edge = .bottom
        }
        
        return edge
    }
    
   
    
}

#if DEBUG
@available(iOS 15.0, *)
#Preview {
    VStack {
        SwiftyButton(title: "filled",props: SwiftyButtonProps(style: .FILLED)) {
            print("Button pressed")
        }
        SwiftyButton(title: "OUTLINE",props: SwiftyButtonProps(style: .OUTLINED)) {
            print("Button pressed")
        }
    }
}

#endif
@available(iOS 13.0, *)
public struct SwiftyButtonProps {
    public var font: Font
    public var cornerRadius: CGFloat
    public var paddingV: CGFloat
    public var paddingH: CGFloat
    public var icon: AnyView?
    public var iconPos: SwiftyButtonIconPos
    public var iconSpacing: CGFloat
    public var showIcon: Bool
    public var shadow: ShadowProps
    public var border: BorderProps
    public var style: SwiftyButtonStyle
    public var colors: SwiftyButtonColors
    
    public init(font: Font = ThemeFonts.SwiftyButton.font, cornerRadius: CGFloat = 10.0, paddingV: CGFloat = 15.0, paddingH: CGFloat = 15.0, icon: AnyView? = nil, iconPos: SwiftyButtonIconPos = .LEFT, iconSpacing: CGFloat = 3.0, showIcon: Bool = true, shadow: ShadowProps = ShadowProps(), border: BorderProps = BorderProps(color: ThemeColors.SwiftyButton.filledFg), style: SwiftyButtonStyle = .FILLED, colors: SwiftyButtonColors = SwiftyButtonColors()) {
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
    }
    
    public func getIconColor() -> Color {
        self.colors.forIcon(self.style)
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
    
    public init(filledFg: Color = ThemeColors.SwiftyButton.filledFg, filledBg: Color = ThemeColors.SwiftyButton.filledBg, outlinedFg: Color = ThemeColors.SwiftyButton.outlinedFg, outlinedBg: Color = ThemeColors.SwiftyButton.outlinedBg) {
        
        self.filledFg = filledFg
        self.filledBg = filledBg
        self.outlinedFg = outlinedFg
        self.outlinedBg = outlinedBg
    }
    
    public func forIcon(_ style: SwiftyButtonStyle) -> Color {
        style == .FILLED ? self.filledFg : self.outlinedFg
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
    case FILLED, OUTLINED, IMAGE_ONLY
}
public enum SwiftyButtonIconPos {
    case LEFT, RIGHT, TOP, BOTTOM
}
