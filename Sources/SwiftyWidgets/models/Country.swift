//
//  File.swift
//  
//
//  Created by Ali Raza on 24/05/2024.
//

import Foundation

@available(iOS 15.0, *)
public struct Country: Codable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let flag: String
    public let code: String
    public let dial_code: String
    public let pattern: String
    public let limit: Int
    
    public static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.id == rhs.id
    }
}

@available(iOS 15.0, *)
public struct Countries {
    public static let allCountry: [Country] = ResourceHelper.decode("CountryNumbers.json")
    
    public static func allCountryNames() -> [String] {
        allCountry.map { country in
            country.name
        }
    }
    public static func getCountry(ofName: String) -> Country? {
        allCountry.filter { country in
            country.name == ofName
        }
        .first
    }
}
