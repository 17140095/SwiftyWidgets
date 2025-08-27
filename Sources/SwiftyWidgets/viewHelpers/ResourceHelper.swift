//
//  BundleHelper.swift
//  SwiftyWidgets
//
//  Created by Ali Raza on 27/08/2025.
//

import Foundation

@available(iOS 15.0, *)
public class ResourceHelper {
    public static func decode<T: Decodable>(_ file: String) -> T {
        let bundle: Bundle
        
        #if SWIFT_PACKAGE
        bundle = Bundle.module
        #else
        // For CocoaPods, try to find the resource bundle
        if let resourceBundle = Bundle(url: Bundle(for: ResourceHelper.self).url(forResource: file, withExtension: nil)!) {
            bundle = resourceBundle
        } else {
            // Fallback to main bundle if resource bundle not found
            bundle = Bundle(for: ResourceHelper.self)
        }
        #endif
        
        return bundle.decode(file)
    }
}

