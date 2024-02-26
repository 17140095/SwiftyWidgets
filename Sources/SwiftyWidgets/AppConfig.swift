//
//  AppConfig.swift
//  
//
//  Created by Ali Raza on 18/01/2024.
//

import Foundation
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
        public static var filledBgColor = AppConfig.primaryColor
        public static var filledFgColor = AppConfig.secondaryColor
        public static var outlinedBgColor = AppConfig.secondaryColor
        public static var outlinedFgColor = AppConfig.primaryColor
        public static var style: SwiftyButtonStyle = .OUTLINED
        public static var radius: CGFloat = 10.0
        public static var effect: SwiftyButtonEffect = .SCALER
    }
    public enum Inputs {
        public static var font = AppConfig.font
        public static var errorFont = AppConfig.Inputs.font
        public static var placeholderColor =  Color.gray
        public static var cursorColor = AppConfig.primaryColor
        public static var leftIconColor = AppConfig.primaryColor
        public static var rightIconColor = AppConfig.primaryColor
        public static var backgroundColor: Color = .clear
        public static var foregroundColor = AppConfig.primaryColor
        public static var clearIcon: Image = Image(systemName: "multiply")
        public static var shouldFloat = false
        public static var style: SwiftyInputStyle = .UNDERLINED
    }
}
