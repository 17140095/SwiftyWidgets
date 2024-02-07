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
    public static var primaryDark = Color(hex: "#5C8984")
    public static var primary = Color(hex: "#92C7CF")
    public static var primaryLight = Color(hex: "#AAD7D9")
    public static var secondary = Color(hex: "#E5E1DA")
    public static var background = Color(hex: "#FBF9F1")
    public static var white = Color.white
    public static var lightGreen = Color(hex: "#d2f5b0")
    public static var lightRed = Color(hex: "#fcbdbd")
    public static var lightGray = Color(hex: "#c2dfff")
    public enum SwiftyInut {
        public static var border = ThemeColors.primary
        public static var tint = ThemeColors.primary
        public static var leftView = ThemeColors.primary
        public static var rightView = ThemeColors.primary
        public static var background: Color = .clear
        public static var forground = ThemeColors.primary
    }
    public enum SwiftyButton {
        public static var border = ThemeColors.primaryDark
        public static var background = ThemeColors.secondary
        public static var forground = ThemeColors.primary
    }
}

@available(iOS 13.0, *)
extension ThemeColors {
    public static var bgColor = Color(hex: "#34495e")
}
