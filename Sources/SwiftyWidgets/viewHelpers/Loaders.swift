//
//  Loader.swift
//  
//
//  Created by Ali Raza on 12/02/2024.
//

import SwiftUI

@available(iOS 15.0, *)
public class Loaders {
    private static var loaderList = [String: AnyView]()
    private static var loaderKey = "Default"
    
    private init() {
        Loaders.loaderList[Loaders.loaderKey] = AnyView(
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(AppConfig.secondaryColor)
                    .padding()
                    .background(AppConfig.primaryColor)
                    .cornerRadius(10)
            }
            .transition(.opacity)
        )
    }
    public static func addLoader(key: String, view: AnyView, makeKeyDefault: Bool = false) {
        loaderList[key] = view
    }
    public static func getLoader(key: String? = nil) -> AnyView {
        if let key = key, let loader = loaderList[key] {
            return loader
        } else if let loader = loaderList[loaderKey] {
            return loader
        } else {
            return AnyView(EmptyView())
        }
    }
}


#if DEBUG

@available(iOS 15.0, *)
struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loaders.getLoader()
    }
}

#endif

