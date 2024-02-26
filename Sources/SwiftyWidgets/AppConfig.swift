//
//  File.swift
//  
//
//  Created by Ali Raza on 26/02/2024.
//

import SwiftUI

@available(iOS 13.0, *)
public enum AppConfig {
    public static var font = Font.body
    public static var primaryColor = Color(hex: "#92C7CF")
    public static var secondaryColor = Color(hex: "#E5E1DA")
    public static var backgroundColor = Color(hex: "#FBF9F1")
    public static var shadowColor = Color.gray
    
    public enum Buttons {
        public static var font = AppConfig.font
        public static var filledBgColor = ThemeColors.primary
        public static var filledFgColor = ThemeColors.secondary
        public static var outlinedBgColor = ThemeColors.secondary
        public static var outlinedFgColor = ThemeColors.primary
        public static var style: SwiftyButtonStyle = .OUTLINED
        public static var radius: CGFloat = 10.0
        public static var effect: SwiftyButtonEffect = .SCALER
    }
    public enum Inputs {
        public static var font = AppConfig.font
        public static var errorFont = AppConfig.Inputs.font
        public static var placeholderColor =  Color.gray
        public static var cursorColor = ThemeColors.primary
        public static var leftIconColor = ThemeColors.primary
        public static var rightIconColor = ThemeColors.primary
        public static var backgroundColor: Color = .clear
        public static var foregroundColor = ThemeColors.primary
        public static var clearIcon: Image = Image(systemName: "multiply")
        public static var shouldFloat = false
        public static var style: SwiftyInputStyle = .UNDERLINED
    }
}
