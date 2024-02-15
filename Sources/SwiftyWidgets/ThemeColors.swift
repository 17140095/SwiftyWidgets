//
//  ThemeColors.swift
//  HealthDiet
//
//  Created by Ali Raza on 18/01/2024.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public enum ThemeColors {
    public static var primary = Color(hex: "#92C7CF")
    public static var secondary = Color(hex: "#E5E1DA")
    public static var background = Color(hex: "#FBF9F1")
    public static var shadow = Color.gray
    
    public enum SwiftyInput {
        public static var placeholderColor =  Color.gray
        public static var border = ThemeColors.primary
        public static var tint = ThemeColors.primary
        public static var leftView = ThemeColors.primary
        public static var rightView = ThemeColors.primary
        public static var background: Color = .clear
        public static var forground = ThemeColors.primary
        public static var font = ThemeFonts.primary
    }
    public enum SwiftyButton {
        public static var filledBg = ThemeColors.primary
        public static var filledFg = ThemeColors.secondary
        public static var outlinedBg = ThemeColors.secondary
        public static var outlinedFg = ThemeColors.primary
        public static var font = ThemeFonts.primary
    }
}

@available(iOS 13.0, *)
extension ThemeColors {
    public static var bgColor = Color(hex: "#34495e")
}
