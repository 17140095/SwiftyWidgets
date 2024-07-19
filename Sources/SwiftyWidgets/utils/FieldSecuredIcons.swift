//
//  FieldSecuredIcons.swift
//
//
//  Created by Ali Raza on 03/07/2024.
//

import SwiftUI

@available(iOS 13.0, *)
public struct FieldSecuredIcons {
    public let secured: Image
    public let unsecured: Image
    
    public init(
        secured: Image = Image(systemName: "eye.fill"),
        unsecured: Image = Image(systemName: "eye.slash.fill")
    ) {
        self.secured = secured
        self.unsecured = unsecured
    }
}
