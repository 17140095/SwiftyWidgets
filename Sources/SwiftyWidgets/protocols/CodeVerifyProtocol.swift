//
//  CodeVerifyProtocol.swift
//
//
//  Created by Ali Raza on 29/05/2024.
//

import Foundation

public protocol CodeVerifyProtocol {
    func verifyCode(emailCode: String?, phoneCode: String?)
    func sendCode(completion: @escaping () -> Void)
}
