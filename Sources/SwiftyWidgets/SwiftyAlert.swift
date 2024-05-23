//
//  SwiftyAlert.swift
//
//
//  Created by Ali Raza on 27/02/2024.
//

import SwiftUI

@available(iOS 15.0, *)
public struct SwiftyAlert: View {
    
    @State private var isAnimating = false
    @Binding private var isPresented: Bool
    private let primaryAction: (name: String, perform: (()-> Void))
    private let secondaryAction: (name: String, perform: (()-> Void))
    private let title: String
    private let message: String
    private let props: SwiftyAlertProps
    
    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        props: SwiftyAlertProps,
        primaryAction: (name: String, perform: () -> Void),
        secondaryAction: (name: String, perform: () -> Void) = ("", {})
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.props = props
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    public var body: some View {
        VStack {
            if isAnimating {
                VStack(spacing: 0) {
                    VStack {
                        /// Image
                        if let header = props.headerImage {
                            HStack {
                                Spacer()
                                header
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .fgStyle(props.primaryColor)
                                    .font(props.iconFont)
                                    .padding(props.headerPadding)
                                Spacer()
                            }
                            .background(props.headerBackground)
                        }
                        
                        /// Title
                        if !title.isEmpty {
                            Text(title)
                                .font(props.font).bold()
                                .fgStyle(props.primaryColor)
                                .padding(props.titlePadding)
                                .zIndex(1)
                        }
                        /// Message
                        Text(message)
                            .fgStyle(props.messageColor)
                            .multilineTextAlignment(.center)
                            .font(props.font)
                            .padding(props.msgPadding)
                        
                        /// Buttons
                        if props.shouldActionsVertical {
                            VStack(spacing: props.actionsSpacing) {
                                PrimaryButton
                                if !secondaryAction.name.isEmpty {
                                    SecondaryButton
                                }
                            }
                        } else {
                            HStack(spacing: props.actionsSpacing) {
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
                    .background(props.background)
                    .cornerRadius(props.cornerRadius)
                    .shadow(props: ShadowProps())
                }
                .padding()
                .transition(.slide)
            }// if
            
        }
        .onAppear(perform: {
            show()
        })
        
    }//body
    
    var SecondaryButton: some View {
        SwiftyButton(title: secondaryAction.name, props: getActionProps(isPrimary: false)) {
            dismiss()
            secondaryAction.perform()
        }
    }
    
    private var PrimaryButton: some View {
        SwiftyButton(title: primaryAction.name, props: getActionProps(isPrimary: true)) {
            dismiss()
            primaryAction.perform()
        }
    }
    
    
    private func dismiss() {
        if #available(iOS 17.0, *) {
            withAnimation(.easeInOut(duration: props.animationDuration)) {
                isAnimating = false
            } completion: {
                isPresented = false
            }
        } else {
            withAnimation(.easeInOut(duration: props.animationDuration)) {
                isAnimating = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + props.animationDuration) {
                isPresented = false
            }
        }
    }
    
    private func show() {
        withAnimation(.easeInOut(duration: props.animationDuration)) {
            isAnimating = true
        }
    }
    
    private func getActionProps(isPrimary: Bool) -> SwiftyButtonProps {
        SwiftyButtonProps(
            font: props.font,
            cornerRadius: props.actionsCornerRadius,
            style: props.actionsStyle,
            colors: SwiftyButtonColors(
                primary: isPrimary ? props.primaryColor : props.secondaryColor,
                secondary: isPrimary ? props.secondaryColor : props.primaryColor
            ),
            effect: .DEFAULT
        )
    }
    
}//SweetyAlert

@available(iOS 15.0, *)
public struct SwiftyAlertProps {
    public let background: Color
    public let headerImage: Image?
    public let headerImageSize: CGFloat
    public let headerBackground: Color
    public let padding: EdgeInsets
    public let headerPadding: EdgeInsets
    public let titlePadding: EdgeInsets
    public let msgPadding: EdgeInsets
    public let actionsPadding: EdgeInsets
    public let actionsCornerRadius: CGFloat
    public let actionsSpacing: CGFloat
    public let shouldActionsVertical: Bool
    public let font: Font
    public let iconFont: Font
    public let primaryColor: Color
    public let secondaryColor: Color
    public let messageColor: Color
    public let cornerRadius: CGFloat
    public let actionsStyle: SwiftyButtonStyle
    public let animationStyle: AnyTransition
    public let animationDuration: CGFloat
    
    public init(
        background: Color = AppConfig.Alert.background,
        headerImage: Image? = nil,
        headerImageSize: CGFloat = AppConfig.Alert.headerImageSize,
        headerBackground: Color = .clear,
        padding: EdgeInsets = AppConfig.Alert.padding,
        headerPadding: EdgeInsets = AppConfig.Alert.headerPadding,
        titlePadding: EdgeInsets = AppConfig.Alert.titlePadding,
        msgPadding: EdgeInsets = AppConfig.Alert.msgPadding,
        actionsPadding: EdgeInsets = AppConfig.Alert.actionsPadding,
        actionsCornerRadius: CGFloat = AppConfig.Alert.actionsCornerRadius,
        actionsSpacing: CGFloat = AppConfig.Alert.actionsSpacing,
        shouldActionsVertical: Bool = AppConfig.Alert.shouldActionsVertical,
        font: Font = AppConfig.Alert.font,
        iconFont: Font = AppConfig.Alert.iconFont,
        primaryColor: Color = AppConfig.Alert.primaryColor,
        secondaryColor: Color = AppConfig.Alert.secondaryColor,
        messageColor: Color = AppConfig.Alert.messageColor,
        cornerRadius: CGFloat = AppConfig.Alert.cornerRadius,
        actionsStyle: SwiftyButtonStyle = AppConfig.Alert.actionsStyle,
        animationStyle: AnyTransition = AppConfig.Alert.animationStyle,
        animationDuration: CGFloat = AppConfig.Alert.animationDuration
    ) {
        
        self.background = background
        self.headerImage = headerImage
        self.headerImageSize = headerImageSize
        self.headerBackground = headerBackground
        self.padding = padding
        self.headerPadding = headerPadding
        self.titlePadding = titlePadding
        self.msgPadding = msgPadding
        self.actionsPadding = actionsPadding
        self.actionsCornerRadius = actionsCornerRadius
        self.actionsSpacing = actionsSpacing
        self.shouldActionsVertical = shouldActionsVertical
        self.font = font
        self.iconFont = iconFont
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.messageColor = messageColor
        self.cornerRadius = cornerRadius
        self.actionsStyle = actionsStyle
        self.animationStyle = animationStyle
        self.animationDuration = animationDuration
    }
    
}

#if DEBUG
@available(iOS 15.0.0, *)
public struct TestSwiftyAlert: View {
    @State private var isPresented: Bool = false
    public var body: some View {
        VStack {
            SwiftyButton(title: "Button") {
                isPresented = true
            }
            SwiftyButton(title: "Button") {
                isPresented = true
            }
            SwiftyButton(title: "Button") {
                isPresented = true
            }
            SwiftyButton(title: "Button") {
                isPresented = true
            }
            SwiftyButton(title: "Button") {
                isPresented = true
            }
        }
        .swiftyAlert(isPresented: $isPresented,title: "Test", message: "This is test alert")
    }
}

@available(iOS 15.0.0, *)
#Preview {
    TestSwiftyAlert()
    
}

#endif
