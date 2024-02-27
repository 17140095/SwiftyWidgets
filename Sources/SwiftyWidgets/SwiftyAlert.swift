//
//  SwiftyAlert.swift
//
//
//  Created by Ali Raza on 27/02/2024.
//

import SwiftUI

public struct SweetyAlert: View {
   
    @Binding private var isPresented: Bool
    private let primaryAction: (name: String, perform: (()-> Void)) //= ("OK", {})
    private let secondaryAction: (name: String, perform: (()-> Void))// = ("", {})
    private let props: SwiftyAlertProps
    @State private var isAnimating = false
    
    public init(
        isPresented: Binding<Bool>,
        props: SwiftyAlertProps,
        primaryAction: (name: String, perform: () -> Void) = ("OK", {}),
        secondaryAction: (name: String, perform: () -> Void) = ("", {})
    ) {
        self._isPresented = isPresented
        self.props = props
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    public var body: some View {
        VStack {
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                    .opacity(isPresented ? 0.6 : 0)
                    .zIndex(1)

                if isAnimating {
                    VStack {
                        VStack {
                            /// Image
                            if let header = props.headerIcon {
                                header
                                    .fgStyle(props.primaryColor)
                            }
                            
                            /// Title
                            if !props.title.isEmpty {
                                Text(props.title)
                                    .font(props.font).bold()
                                    .fgStyle(props.primaryColor)
                                    .padding(8)
                            }
                            /// Message
                            Group {
                                Text(self.props.message)
                            }
                            .multilineTextAlignment(.center)

                            /// Buttons
                            HStack(spacing: props.shouldBottomStickAction ? 0 : 5) {
                                PrimaryButton
                                if !secondaryAction.name.isEmpty {
                                    SecondaryButton
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(if: !props.shouldBottomStickAction)
                            .frame(maxWidth: .infinity)
                        }
                        .padding(if: !props.shouldBottomStickAction)
                        .frame(maxWidth: .infinity)
                        .background(.background)
                        .cornerRadius(props.cornerRadius)
                    }
                    .padding()
                    .transition(.slide)
                    .zIndex(2)
                }
                
            }
            .onAppear(perform: {
                show()
            })
        }
        
    }//body
    
    var SecondaryButton: some View {
        SwiftyButton(title: secondaryAction.name, props: SwiftyButtonProps(colors: SwiftyButtonColors(filledFg: props.primaryColor, filledBg: props.secondaryColor))) {
            dismiss()
            secondaryAction.perform()
        }
    }

    var PrimaryButton: some View {
        SwiftyButton(title: primaryAction.name, props: SwiftyButtonProps()) {
            dismiss()
            primaryAction.perform()
        }
    }
    
    func dismiss() {
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
    
    func show() {
        withAnimation(.easeInOut(duration: props.animationDuration)) {
            isAnimating = true
        }
    }
    
    
}//SweetyAlert

public struct SwiftyAlertProps {
    public let title: String
    public let message: String
    public let headerIcon: Image?
    public let actionsPos: SwiftyAlertActionsPos
    public let font: Font = AppConfig.font
    public let primaryColor: Color = AppConfig.primaryColor
    public let secondaryColor: Color = AppConfig.secondaryColor
    public let actionProps: SwiftyButtonProps
    public let cornerRadius: CGFloat
    public let animationStyle: AnyTransition
    public let animationDuration: CGFloat
    public let shouldBottomStickAction: Bool
    
    public init(
        title: String = "",
        message: String,
        headerIcon: Image? = nil,
        actionsPos: SwiftyAlertActionsPos = .HORIZONTAL,
        actionProps: SwiftyButtonProps = SwiftyButtonProps(),
        cornerRadius: CGFloat = 15.0,
        animationStyle: AnyTransition = .slide,
        animationDuration: CGFloat = 0.5,
        shouldBottomStickAction: Bool = true
    ) {
        self.title = title
        self.message = message
        self.headerIcon = headerIcon
        self.actionsPos = actionsPos
        self.actionProps = actionProps
        self.cornerRadius = cornerRadius
        self.animationStyle = animationStyle
        self.animationDuration = animationDuration
        self.shouldBottomStickAction = shouldBottomStickAction
    }
}

public enum SwiftyAlertActionsPos {
    case VERTICAL, HORIZONTAL
}

public enum SwiftyAlertTypes {
    case SWEETY, FLOATY
}

#Preview {
    SwiftyAlert()
}
