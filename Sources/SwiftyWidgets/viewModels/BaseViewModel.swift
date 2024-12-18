//
//  BaseViewModel.swift
//
//
//  Created by Ali Raza on 29/05/2024.
//

import Foundation

@available(iOS 13.0, *)
public class BaseViewModel:NSObject, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    var alertTitle = "Error"
    var errorMessage = ""
    
    var apiTask: URLSessionDataTask?
    
    func showError(msg: String, title: String = "Error") {
        self.errorMessage = msg
        self.isLoading = false
        self.showAlert = true
        self.alertTitle = title
    }
    
    func cancelApiCalls() {
        apiTask?.cancel()
    }
}
