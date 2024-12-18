//
//  NavigationControl.swift
//  SwiftyWidgets
//
//  Created by Ali Raza on 28/09/2024.
//
import SwiftUI

@available(iOS 16.0, *)
public class NavigationControl: ObservableObject {
    @Published public var path = NavigationPath()
    public var plainPath: [String] = []
    
    public func next(_ screen: any Hashable) {
        if plainPath.contains(String(describing: screen)) {
            #if DEBUG
            print("Screen already exists in the path")
            #endif
            return
        }
        path.append(screen)
        plainPath.append(String(describing: screen))
    }
    
    public func back(step:Int? = nil) {
        if path.isEmpty || path.count < step ?? 0 {
            return
        }
        if let step {
            path.removeLast(step)
            plainPath.removeLast(step)
        } else {
            path.removeLast()
            plainPath.removeLast()
        }
    }
    
    public func getPlainPath(separator: String = "/") -> String {
        plainPath.joined(separator: separator)
    }
    
    public func clear() {
        path.removeLast(path.count)
        plainPath.removeAll()
    }
}
