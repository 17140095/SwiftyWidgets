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
        .font(props.font)
        .foregroundStyle(getFgColor(props: props))
        .shadow(props: props.shadow)
        .contentShape(RoundedRectangle(cornerRadius: props.cornerRadius))
        .background(getBgColor(props: props))
        .clipShape(RoundedRectangle(cornerRadius: props.cornerRadius))
        
        .overlay(if: props.showBorder){
            RoundedRectangle(cornerRadius: props.cornerRadius)
                .stroke(props.border.color, lineWidth: props.border.width)
        }
    }
    
    private func getBgColor(props: SwiftyButtonProps) -> Color {
        props.style == .OUTLINED ? props.backgroundColor : props.forgroundColor
    }
    private func getFgColor(props: SwiftyButtonProps) -> Color {
        props.style == .OUTLINED ? props.forgroundColor : props.backgroundColor
    }
    
    @ViewBuilder
    private func buildView( iconPos: SwiftyButtonIconPos = .LEFT) -> some View {
       
        VStack(spacing: 0) {
            if props.showIcon, iconPos == .TOP {
                props.icon
                    .tint(props.iconColor)
            }
            HStack {
                Spacer()
                if props.showIcon, iconPos == .LEFT {
                    props.icon
                        .tint(props.iconColor)
                }
                if props.style != .IMAGE_ONLY {
                    Text(title)
                        .tint(props.forgroundColor)
                        .padding(getIconSpaceEdge(), props.iconSpacing)
                }
                if props.showIcon, iconPos == .RIGHT {
                    props.icon
                        .tint(props.iconColor)
                }
                Spacer()
            }
            if props.showIcon, iconPos == .BOTTOM {
                props.icon
                    .tint(props.iconColor)
            }
        }
        .padding(.vertical, props.paddingV)
        .padding(.horizontal, props.paddingH)
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
    HStack {
        SwiftyButton(title: "Press",props: SwiftyButtonProps()) {
            print("Button pressed")
        }
    }
}

#endif
@available(iOS 15.0, *)
public struct SwiftyButtonProps {
    public var font: Font
    public var forgroundColor: Color
    public var backgroundColor: Color
    public var cornerRadius: CGFloat
    public var paddingV: CGFloat
    public var paddingH: CGFloat
    public var icon: AnyView
    public var iconPos: SwiftyButtonIconPos
    public var iconSpacing: CGFloat
    public var iconColor: Color
    public var showIcon: Bool
    public var shadow: ShadowProps
    public var border: BorderProps
    public var showBorder: Bool
    public var style: SwiftyButtonStyle
    
    public init(font: Font = ThemeFonts.primary, forgroundColor: Color = ThemeColors.SwiftyButton.forground, backgroundColor: Color = ThemeColors.SwiftyButton.background, cornerRadius: CGFloat = 50.0, paddingV: CGFloat = 15.0, paddingH: CGFloat = 15.0, icon: AnyView = AnyView(Image(systemName: "cross")), iconPos: SwiftyButtonIconPos = .LEFT, iconSpacing: CGFloat = 3.0, iconColor: Color = ThemeColors.SwiftyButton.forground, showIcon: Bool = true, shadow: ShadowProps = ShadowProps(), border: BorderProps = BorderProps(color: ThemeColors.SwiftyButton.border), showBorder: Bool = true, style: SwiftyButtonStyle = .FILLED) {
        self.font = font
        self.forgroundColor = forgroundColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.paddingV = paddingV
        self.paddingH = paddingH
        self.icon = icon
        self.iconPos = iconPos
        self.iconSpacing = iconSpacing
        self.iconColor = iconColor
        self.showIcon = showIcon
        self.shadow = shadow
        self.border = border
        self.showBorder = showBorder
        self.style = style
    }
}

@available(iOS 15.0, *)
public struct BorderProps {
    public var color: Color = ThemeColors.primary
    public var width: CGFloat = 2.0
    
    public init(color: Color = ThemeColors.primary, width: CGFloat = 2.0) {
        self.color = color
        self.width = width
    }
}

@available(iOS 15.0, *)
public struct ShadowProps {
    public var color: Color = ThemeColors.SwiftyButton.background .opacity(0.33)
    public var radius: CGFloat = 5.0
    public var x: CGFloat = 5.0
    public var y: CGFloat = 5.0
    public var apply: Bool = true
    
    public init(color: Color = ThemeColors.SwiftyButton.background .opacity(0.33), radius: CGFloat = 5.0, x: CGFloat = 5.0, y: CGFloat = 5.0, apply: Bool = true) {
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
