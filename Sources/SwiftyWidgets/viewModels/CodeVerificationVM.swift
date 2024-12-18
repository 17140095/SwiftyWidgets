//
//  File.swift
//  
//
//  Created by Ali Raza on 02/08/2024.
//

import SwiftUI

@available(iOS 13.0, *)
public class CodeVerificationVM: BaseViewModel {
    
    @Published var phoneText: String = ""
    @Published var emailText: String = ""
//    @Published var goOTP: Bool = false
    @Published var isOtpVerified = false
    
    var by: CodeVerificationBy = .BOTH
    var delegate: CodeVerifyProtocol?
    
    public init(phone: String = "", email: String = "", by: CodeVerificationBy = .BOTH) {
        self.phoneText = phone
        self.emailText = email
        self.by = by
    }
}



