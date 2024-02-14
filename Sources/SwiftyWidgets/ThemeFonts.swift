//
//  ThemeFonts.swift
//  PodTest
//
//  Created by Ali Raza on 02/02/2024.
//

import SwiftUI

@available(iOS 13.0, *)
public enum ThemeFonts {
    public static var primary = Font.body
    
    public enum SwiftyButton {
        public static var font = ThemeFonts.primary
    }
    public enum SwiftyInput {
        public static var font = ThemeFonts.primary
        public static var errorFont = ThemeFonts.SwiftyInput.font
    }
}
