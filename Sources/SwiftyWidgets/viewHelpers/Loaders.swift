//
//  Loader.swift
//  
//
//  Created by Ali Raza on 12/02/2024.
//

import SwiftUI

@available(iOS 13.0, *)
public struct Loader: View {
    public let key: String
    public let content: AnyView
    
    public init(key: String, content: AnyView) {
        self.key = key
        self.content = content
    }
    public var body: some View {
        content
    }
}

@available(iOS 16.0, *)
open class LoadingViews {
    private var loaders: [String: Loader] = [:]
    private var key: String = "Default"
    
    private static var instance: LoadingViews = LoadingViews()
    
    private init() {
        loaders[key] = getDefaultLoader()
    }
    
    public static func getInstance() -> LoadingViews {
        return instance
    }
    
    public func addLoader( shouldSet: Bool = true, _ loader: Loader) {
        
        self.loaders[loader.key] = loader
        if shouldSet {
            self.key = loader.key
        }
    }
    
    public func getLoader(key: String? = nil) -> Loader? {
        if let key = key {
            return loaders[key]
        } else {
            return loaders[self.key]
        }
    }
    
    private func getDefaultLoader() -> Loader {
        Loader(key: "Default", content: AnyView(
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(AppConfig.secondaryColor)
                    .padding()
                    .background(AppConfig.primaryColor)
                    .cornerRadius(10)
            }
            .transition(.opacity)
        ))
    }
}

#if DEBUG

@available(iOS 13.0, *)
struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loader(key: "test", content: AnyView(Text("Loader")))
    }
}

#endif

