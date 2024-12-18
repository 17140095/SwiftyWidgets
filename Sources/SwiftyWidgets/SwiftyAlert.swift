//
//  SwiftyAlert.swift
//
//
//  Created by Ali Raza on 27/02/2024.
//

import SwiftUI

@available(iOS 16.0, *)
public struct SwiftyAlert: View, BaseProps {
    public var primaryColor: Color = AppConfig.Alert.primaryColor
    public var secondaryColor: Color = AppConfig.Alert.secondaryColor
    public var border: BorderProps? = nil
    public var shadow: ShadowProps? = nil
    public var cornerRadius: CGFloat = AppConfig.Alert.cornerRadius
    public var padding: EdgeInsets = AppConfig.Alert.padding
    public var font: Font = AppConfig.Alert.font
    
    public var background: Color = AppConfig.Alert.background
    public var headerImage: Image? = nil
    public var headerImageSize: CGFloat = AppConfig.Alert.headerImageSize
    public var headerBackground: Color = AppConfig.Alert.headerBackground
    public var headerPadding: EdgeInsets = AppConfig.Alert.headerPadding
    public var titlePadding: EdgeInsets = AppConfig.Alert.titlePadding
    public var msgPadding: EdgeInsets = AppConfig.Alert.msgPadding
    public var shouldActionsVertical: Bool = AppConfig.Alert.shouldActionsVertical
    public var iconFont: Font = AppConfig.Alert.iconFont
    public var messageColor: Color = AppConfig.Alert.messageColor
    public var animationStyle: AnyTransition = AppConfig.Alert.animationStyle
    public var animationDuration: CGFloat = AppConfig.Alert.animationDuration
    
    public var actionsPadding: EdgeInsets = AppConfig.Alert.actionsPadding
    public var actionsCornerRadius: CGFloat = AppConfig.Alert.actionsCornerRadius
    public var actionsSpacing: CGFloat = AppConfig.Alert.actionsSpacing
    public var actionsFont: Font = AppConfig.Alert.actionsFont
    public var applyActionsScalerEffect: Bool = AppConfig.Alert.applyActionsScalerEffect
    
    @State private var isAnimating = false
    @Binding private var isPresented: Bool
    private let primaryAction: (name: String, perform: (()-> Void))
    private let secondaryAction: (name: String, perform: (()-> Void))
    private let title: String
    private let message: String
    
    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryAction: (name: String, perform: () -> Void),
        secondaryAction: (name: String, perform: () -> Void) = ("", {})
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    public var body: some View {
        VStack {
            if isAnimating {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        /// header of image and title
                        VStack(spacing: 0) {
                            if let header = headerImage {
                                header
                                    .resizable()
                                    .frame(width: headerImageSize, height: headerImageSize)
                                    .fgStyle(primaryColor)
                                    .font(iconFont)
                                    .padding(headerPadding)
                                    .frame(maxWidth: .infinity)
                            }
                            if !title.isEmpty {
                                Text(title)
                                    .font(font).bold()
                                    .fgStyle(primaryColor)
                                    .padding(titlePadding)
                                    .frame(maxWidth: .infinity)
                                    .zIndex(1)
                            }
                        }
                        .background(headerBackground)
                        
                        Divider()
                        
                        /// Message
                        Text(message)
                            .fgStyle(messageColor)
                            .multilineTextAlignment(.center)
                            .font(font)
                            .padding(msgPadding)
                            .frame(minHeight: 100)
                        
                        Divider()
                        /// Buttons
                        if shouldActionsVertical {
                            VStack(spacing: actionsSpacing) {
                                PrimaryButton
                                if !secondaryAction.name.isEmpty {
                                    SecondaryButton
                                }
                            }
                        } else {
                            HStack(spacing: actionsSpacing) {
                                PrimaryButton
                                if !secondaryAction.name.isEmpty {
                                    SecondaryButton
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .border(props: border)
                    .background(background)
                    .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .shadow(props: shadow)
                }
                .padding()
                .transition(animationStyle)
            }// if
            
        }
        .onAppear(perform: {
            show()
        })
        
    }//body
    
    var SecondaryButton: some View {
        SwiftyButton(title: secondaryAction.name) {
            dismiss()
            secondaryAction.perform()
        }
        .setFont(actionsFont)
        .setCornerRadius(actionsCornerRadius)
        .setPrimaryColor(secondaryColor)
        .setSecondaryColor(primaryColor)
        .setEffectScaler(if: applyActionsScalerEffect)
    }
    
    private var PrimaryButton: SwiftyButton {
        SwiftyButton(title: primaryAction.name) {
            dismiss()
            primaryAction.perform()
        }
        .setFont(actionsFont)
        .setCornerRadius(actionsCornerRadius)
        .setPrimaryColor(primaryColor)
        .setSecondaryColor(secondaryColor)
        .setEffectScaler(if: applyActionsScalerEffect)
    }
    
    
    private func dismiss() {
        if #available(iOS 17.0, *) {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isAnimating = false
            } completion: {
                isPresented = false
            }
        } else {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isAnimating = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                isPresented = false
            }
        }
    }
    
    private func show() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            isAnimating = true
        }
    }
    
    public func setPrimaryColor(_ color: Color) -> SwiftyAlert {
        var alert = self
        alert.primaryColor = color
        return alert
    }
    public func setSecondaryColor(_ color: Color) -> SwiftyAlert {
        var alert = self
        alert.secondaryColor = color
        return alert
    }
    public func setBorder(_ border: BorderProps) -> SwiftyAlert {
        var alert = self
        alert.border = border
        alert.border?.cornerRadius = cornerRadius
        return alert
    }
    public func setShadow(_ shadow: ShadowProps) -> SwiftyAlert {
        var alert = self
        alert.shadow = shadow
        return alert
    }
    public func setCornerRadius(_ radius: CGFloat) -> SwiftyAlert {
        var alert = self
        alert.cornerRadius = radius
        return alert
    }
    public func setPadding(_ padding: EdgeInsets) -> SwiftyAlert {
        var alert = self
        alert.padding = padding
        return alert
    }
    public func setFont(_ font: Font) -> SwiftyAlert {
        var alert = self
        alert.font = font
        return alert
    }
    
    public func setBackGround(_ color: Color) -> SwiftyAlert {
        var alert = self
        alert.background = color
        return alert
    }
    public func setHeaderImage(_ image: Image) -> SwiftyAlert {
        var alert = self
        alert.headerImage = image
        return alert
    }
    public func setHeaderImageSize(_ size: CGFloat) -> SwiftyAlert {
        var alert = self
        alert.headerImageSize = size
        return alert
    }
    public func setHeaderBackground(_ color: Color) -> SwiftyAlert {
        var alert = self
        alert.headerBackground = color
        return alert
    }
    public func setHeaderPadding(_ padding: EdgeInsets) -> SwiftyAlert {
        var alert = self
        alert.headerPadding = padding
        return alert
    }
    public func setTitlePadding(_ padding: EdgeInsets) -> SwiftyAlert {
        var alert = self
        alert.titlePadding = padding
        return alert
    }
    public func setTitlePadding(_ value: CGFloat) -> SwiftyAlert {
        var alert = self
        alert.titlePadding = EdgeInsets(top: value, leading: value, bottom: value, trailing: value)
        return alert
    }
    public func setMsgPadding(_ padding: EdgeInsets) -> SwiftyAlert {
        var alert = self
        alert.msgPadding = padding
        return alert
    }
    public func setShouldActionsVertical(_ should: Bool) -> SwiftyAlert {
        var alert = self
        alert.shouldActionsVertical = should
        return alert
    }
    public func setIconFont(_ font: Font) -> SwiftyAlert {
        var alert = self
        alert.iconFont = font
        return alert
    }
    public func setMessageColor(_ color: Color) -> SwiftyAlert {
        var alert = self
        alert.messageColor = color
        return alert
    }
    public func setAnimationStyle(_ style: AnyTransition) -> SwiftyAlert {
        var alert = self
        alert.animationStyle = style
        return alert
    }
    public func setAnimationDuration(_ duration: CGFloat) -> SwiftyAlert {
        var alert = self
        alert.animationDuration = duration
        return alert
    }
    public func setActionsPadding(_ padding: EdgeInsets) -> SwiftyAlert {
        var alert = self
        alert.actionsPadding = padding
        return alert
    }
    public func setActionsCornerRadius(_ radius: CGFloat) -> SwiftyAlert {
        var alert = self
        alert.actionsCornerRadius = radius
        return alert
    }
    public func setActionsSpacing(_ spacing: CGFloat) -> SwiftyAlert {
        var alert = self
        alert.actionsSpacing = spacing
        return alert
    }
    public func setActionsFont(_ font: Font) -> SwiftyAlert {
        var alert = self
        alert.actionsFont = font
        return alert
    }
    public func setApplyActionsScalerEffect() -> SwiftyAlert {
        var alert = self
        alert.applyActionsScalerEffect = true
        return alert
    }
    
}//SwifptyAlert



#if DEBUG
@available(iOS 16.0, *)
public struct TestSwiftyAlert: View {
    @State private var isPresented: Bool = false
    @State private var isPresented1: Bool = false
    @State private var isPresented2: Bool = false
    @State private var isPresented3: Bool = false
    
    public var body: some View {
        VStack {
            SwiftyButton(title: "Button") {
                isPresented = true
            }
            .setPrimaryColor(.red)
           
            
            SwiftyButton(title: "Button") {
                isPresented1 = true
            }
            
            SwiftyButton(title: "Button") {
                isPresented2 = true
            }
            SwiftyButton(title: "Button") {
                isPresented3 = true
            }
            
            
            SwiftyButton(title: "Button") {
                isPresented = true
            }
        }
        .swiftyAlert(isPresented: $isPresented,title: "Test", message: "This is test alert")
        .swiftyAlert(isPresented: $isPresented1,title: "Test", message: "This is test alert", primaryAction: (name: "OK1", {}), secondaryAction: (name: "Cancel1", {}))
        .swiftyAlert(isPresented: $isPresented3) {
            SwiftyAlert(isPresented: $isPresented3, title: "Test 3", message: "This is test 3 message This is test 3 message This is test 3 message", primaryAction: (name:"OK3", {}), secondaryAction: (name: "Cancel3", {}))
//                .setBackGround(.red)
                .setHeaderImage(Image(systemName: "person"))
//                .setHeaderImageSize(24)
//                .setHeaderBackground(.yellow)
//                .setTitlePadding(20)
                .setApplyActionsScalerEffect()
                .setBorder(BorderProps(color: .red, width: 2))
        }
    }
}

@available(iOS 16.0, *)
#Preview {
    TestSwiftyAlert()
    
}

#endif
