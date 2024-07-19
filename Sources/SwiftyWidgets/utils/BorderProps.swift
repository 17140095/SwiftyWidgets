//
//  BorderProps.swift
//  
//
//  Created by Ali Raza on 03/07/2024.
//

import SwiftUI

@available(iOS 15.0, *)
public struct BorderProps {
    public var color: Color
    public var width: CGFloat
    public var cornerRadius: CGFloat
    public init(color: Color = AppConfig.primaryColor, width: CGFloat = 1.0, cornerRadius: CGFloat = 0.0) {
        self.color = color
        self.width = width
        self.cornerRadius = cornerRadius
    }
    
    public func getFocusWidth() -> CGFloat {
        self.width + 1.0
    }
}
