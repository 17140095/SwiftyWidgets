//
//  CodeVerifyProtocol.swift
//
//
//  Created by Ali Raza on 29/05/2024.
//

import Foundation

public protocol CodeVerifyProtocol {
    func verifyCode(code: String, codeType: CodeVerificationBy)
    func resendCode(codeType: CodeVerificationBy)
    func verifyCode(code: String, codeType: CodeVerificationBy, completion: @escaping (Bool) -> Void)
    func resendCode(codeType: CodeVerificationBy, completion: @escaping (Bool) -> Void)
}
