//
//  AppConfig.swift
//  
//
//  Created by Ali Raza on 18/01/2024.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public enum AppConfig {
    public static var font = Font.body
    public static var primaryColor = Color(hex: "#92C7CF")
    public static var secondaryColor = Color(hex: "#E5E1DA")
    public static var backgroundColor = Color(hex: "#FBF9F1")
    public static var shadowColor = Color.gray
    public static var defaultTextColor = Color(hex: "#454545")
    public static var navigationTitleFont = Font.system(size: 20)
    public static var navigationTitleColor = AppConfig.primaryColor
    public static var navigationBackButtonView: (()-> AnyView)? = nil
    
    public enum Buttons {
        public static var font = AppConfig.font
        public static var filledBgColor = AppConfig.primaryColor
        public static var filledFgColor = AppConfig.secondaryColor
        public static var outlinedBgColor = AppConfig.secondaryColor
        public static var outlinedFgColor = AppConfig.primaryColor
        public static var style: SwiftyButtonStyle = .FILLED
        public static var borderProps = BorderProps(color: AppConfig.Buttons.filledFgColor)
        public static var radius: CGFloat = 10.0
        public static var padding = EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        public static var effect: SwiftyButtonEffect = .SCALER
    }
    public enum Inputs {
        public static var font = AppConfig.font
        public static var errorFont = AppConfig.Inputs.font
        public static var placeholderColor =  Color.gray
        public static var cursorColor = AppConfig.primaryColor
        public static var leftViewSpace: CGFloat = 5.0
        public static var rightViewSpace: CGFloat = 5.0
        public static var leftIconColor = AppConfig.primaryColor
        public static var rightIconColor = AppConfig.primaryColor
        public static var backgroundColor: Color = .clear
        public static var foregroundColor = AppConfig.primaryColor
        public static var errorMsgs = ErrorMsgs()
        public static var clearIcon: Image = Image(systemName: "multiply")
        public static var shouldFloat = false
        public static var style: SwiftyInputStyle = .UNDERLINED
        public static var securedIcons = SwiftyInputSecureIcons()
        public static var cornerRadius: CGFloat = 0
        public static var hPaddingForBordered: CGFloat = 10
    }
    
    public enum Alert {
        public static var background = AppConfig.backgroundColor
        public static var font = AppConfig.font
        public static var iconFont = AppConfig.font
        public static var cornerRadius = 30.0
        public static var primaryColor: Color = AppConfig.primaryColor
        public static var secondaryColor: Color = AppConfig.secondaryColor
        public static var animationDuration: CGFloat = 0.5
        public static var animationStyle: AnyTransition = .slide
        public static var actionsStyle: SwiftyButtonStyle = .FILLED
        public static var shouldActionsVertical: Bool = false
        public static var actionsSpacing: CGFloat = 0.0
        public static var actionsCornerRadius: CGFloat = 0.0
        public static var padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        public static var headerPadding: EdgeInsets = EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10)
        public static var titlePadding: EdgeInsets = EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        public static var msgPadding: EdgeInsets = EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        public static var actionsPadding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        public static var headerImageSize: CGFloat = 50
        public static var messageColor = AppConfig.defaultTextColor
    }
    
    public enum Selectors {
        public enum ImageSelector {
            public static var color = AppConfig.primaryColor
            public static var width: CGFloat = 3
        }
        
        public enum SegmentedSelector {
            public static var font: Font = AppConfig.font
            public static var cRadius: CGFloat = 10.0
            public static var primaryColor: Color = AppConfig.primaryColor
            public static var secondaryColor: Color = AppConfig.secondaryColor
            public static var showBorder: Bool = false
            public static var roundStyle: PickerRoundStyle = .NO_ROUND
            public static var spacing: CGFloat = 1
            public static var direction: Axis.Set = .horizontal
            public static var padding: EdgeInsets = EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            public static var borderWidth: CGFloat = 2
        }
        
        public enum InputSelector {
            public static var font = AppConfig.font
            public static var cornerRadius: CGFloat = 10
            public static var primaryColor = AppConfig.primaryColor
            public static var backgroundColor = Color.white
            public static var image = Image(systemName: "arrowtriangle.down.fill")
        }
    }
    
}
