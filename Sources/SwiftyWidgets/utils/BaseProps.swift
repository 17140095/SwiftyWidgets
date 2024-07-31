//
//  BaseProps.swift
//  
//
//  Created by Ali Raza on 03/07/2024.
//

import SwiftUI

@available(iOS 15.0, *)
public protocol BaseProps {
    var primaryColor: Color { get set }
    var secondaryColor: Color { get set }
    var border: BorderProps? { get set }
    var shadow: ShadowProps? { get set }
    var cornerRadius: CGFloat { get set }
    var padding: EdgeInsets { get set }
    var font: Font { get set }
    
    //write setters
    func setPrimaryColor(_ color: Color) -> Self
    func setSecondaryColor(_ color: Color) -> Self
    func setBorder(_ border: BorderProps) -> Self
    func setShadow(_ shadow: ShadowProps) -> Self
    func setCornerRadius(_ radius: CGFloat) -> Self
    func setPadding(_ padding: EdgeInsets) -> Self
    func setFont(_ font: Font) -> Self
    
}
