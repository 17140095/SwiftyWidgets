//
//  SwiftyButton.swift
//
//  Created by Ali Raza on 21/01/2024.
//

import SwiftUI

public enum SwiftyButtonIconPos {
    case LEFT, RIGHT, TOP, BOTTOM
}

@available(iOS 15.0.0, *)
public struct SwiftyButton: View, BaseProps {
    public var primaryColor: Color = AppConfig.primaryColor
    public var secondaryColor: Color = AppConfig.secondaryColor
    public var border: BorderProps? = AppConfig.Buttons.borderProps
    public var shadow: ShadowProps? = nil
    public var cornerRadius: CGFloat = AppConfig.Buttons.radius
    public var padding: EdgeInsets = AppConfig.Buttons.padding
    public var font: Font = AppConfig.Buttons.font
    
    public var icon: Image? = nil
    public var iconPos: SwiftyButtonIconPos = .LEFT
    public var iconSpacing: CGFloat = 0.0
    public var showOnlyIcon: Bool = false
    public var style: any LabelStyle
    public var effect: (any ButtonStyle)? = nil
    
    public let title: String
    public let onPress: ()-> Void
    
    public init(title: String, onPress: @escaping () -> Void) {
        self.title = title
        self.onPress = onPress
        self.style = SwiftyButtonLabelStyle(iconPos: iconPos, showOnlyIcon: showOnlyIcon, iconSpacing: iconSpacing)
    }
    
    public var body: some View {
        Button(action: {
            onPress()
        }) {
            buildFilledOutlineView()
        }
        .fgStyle(secondaryColor)
        .buttonStyle(ScaleEffectStyle(font: font, fgColor: secondaryColor), if: effect != nil)
    }
    
    @ViewBuilder
    private func buildFilledOutlineView() -> some View {
       
        HStack(spacing: 0) {
            Spacer()
                Label {
                    Text(showOnlyIcon ? "" : title)
                } icon: {
                    if let icon {
                        icon
                            .fgStyle(secondaryColor)
                            .scaledToFit()
                    }
                }
                .font(font)
                .labelStyle(SwiftyButtonLabelStyle(iconPos: iconPos, showOnlyIcon: showOnlyIcon, iconSpacing: iconSpacing))
            Spacer()
        }
        .padding(padding)
        .font(font)
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
        .background(primaryColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(props: shadow)
        .overlay {
            if let border {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(border.color, lineWidth: border.width)
            }
        }
    }
    
    public func setPrimaryColor(_ color: Color) -> Self {
        var view = self
        view.primaryColor = color
        return view
    }
    public func setSecondaryColor(_ color: Color) -> Self {
        var view = self
        view.secondaryColor = color
        return view
    }
    
    public func setBorder(_ border: BorderProps) -> SwiftyButton {
        var view = self
        view.border = border
        return view
    }
    public func setShadow(_ shadow: ShadowProps) -> SwiftyButton {
        var view = self
        view.shadow = shadow
        return view
    }
    public func setCornerRadius(_ radius: CGFloat) -> SwiftyButton {
        var view = self
        view.cornerRadius = radius
        return view
    }
    public func setPadding(_ padding: EdgeInsets) -> SwiftyButton {
        var view = self
        view.padding = padding
        return view
    }
    public func setFont(_ font: Font) -> SwiftyButton {
        var view = self
        view.font = font
        return view
    }
    public func setIcon(_ icon: Image) -> SwiftyButton {
        var view = self
        view.icon = icon
        return view
    }
    public func setIconPos(_ pos: SwiftyButtonIconPos) -> SwiftyButton {
        var view = self
        view.iconPos = pos
        return view
    }
    public func setIconSpacing(_ spacing: CGFloat) -> SwiftyButton {
        var view = self
        view.iconSpacing = spacing
        return view
    }
    public func setShowOnlyIcon() -> SwiftyButton {
        var view = self
        view.showOnlyIcon = true
        return view
    }
    public func setStyle(_ style: any LabelStyle) -> SwiftyButton {
        var view = self
        view.style = style
        return view
    }
    public func setEffect(_ effect: any ButtonStyle) -> SwiftyButton {
        var view = self
        view.effect = effect
        return view
    }
    public func setEffectScaler(if condition: Bool = true) -> SwiftyButton {
        var view = self
        if condition {
            view.effect = ScaleEffectStyle(font: font, fgColor: secondaryColor)
        }
        return view
    }
}//SwiftyButton1

@available(iOS 15.0, *)
fileprivate struct SwiftyButtonLabelStyle: LabelStyle {
    
    private var iconPos: SwiftyButtonIconPos
    private var showOnlyIcon: Bool
    private var spacing: CGFloat = 0.0
    
    public init(iconPos: SwiftyButtonIconPos, showOnlyIcon: Bool, iconSpacing: CGFloat) {
        self.iconPos = iconPos
        self.showOnlyIcon = showOnlyIcon
        self.spacing = showOnlyIcon ? 0.0 : iconSpacing
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        if showOnlyIcon {
            configuration.icon
        } else {
            getView(configuration: configuration)
        }
    }
    
    @ViewBuilder
    private func getView(configuration: Configuration) -> some View {
        switch iconPos {
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

@available(iOS 15.0.0, *)
fileprivate struct ScaleEffectStyle: ButtonStyle {

    private var font: Font
    private var fgColor: Color
    public init(font: Font, fgColor: Color) {
        self.font = font
        self.fgColor = fgColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(fgColor)
            .font(font)
            .scaleEffect(configuration.isPressed ? 0.6 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#if DEBUG
@available(iOS 15.0, *)
#Preview{
    VStack {
        SwiftyButton(title: "filled") {
            print("Button pressed")
        }
        .setPrimaryColor(.red)
        .setSecondaryColor(.yellow)
        .setBorder(BorderProps(color: .blue, width: 2.0))
        .setCornerRadius(20.0)
        .setPadding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .setFont(.largeTitle)
        .setIcon(Image(systemName: "person"))
        .setIconPos(.RIGHT)
        .setIconSpacing(5.0)
        .setEffectScaler()
    }
}

@available(iOS 15.0, *)
#Preview {
    ScrollView {
        VStack(spacing: 20) {

        }
    }//scroll
}


#endif
