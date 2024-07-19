//
//  BaseParser.swift
//  
//
//  Created by Ali Raza on 02/07/2024.
//

import Foundation

public struct ServiceResponse<ResponsePayload: Codable>: Codable {
    var responseCode: String?
    var responseDescription: String?
    var responsePayload: ResponsePayload?
}

public struct ParsedResponse<T> {
    var responseCode: String?
    var responseDescription: String?
    var responsePayload: T?
    
    init(responseCode: String?, responseDescription: String?, responsePayload: T?) {
        self.responseCode = responseCode
        self.responseDescription = responseDescription
        self.responsePayload = responsePayload
    }
}
