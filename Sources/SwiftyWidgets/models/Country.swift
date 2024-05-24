//
//  File.swift
//  
//
//  Created by Ali Raza on 24/05/2024.
//

import Foundation

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

public struct Countries {
    public static let allCountry: [Country] = Bundle.module.decode("CountryNumbers.json")
    
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
