//
//  ShadowProps.swift
//
//
//  Created by Ali Raza on 03/07/2024.
//

import SwiftUI

@available(iOS 15.0, *)
public struct ShadowProps {
    public var color: Color
    public var radius: CGFloat
    public var x: CGFloat
    public var y: CGFloat
    
    public init(color: Color = AppConfig.shadowColor, radius: CGFloat = 5.0, x: CGFloat = 5.0, y: CGFloat = 5.0) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}
