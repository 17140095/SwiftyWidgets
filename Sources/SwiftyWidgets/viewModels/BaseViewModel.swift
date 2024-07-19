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
    @Published var showError: Bool = false
    @Published var isSucces = false
    
    var errorMessage = ""
    var isErrorForSuccess: Bool = false
    
    var apiTask: URLSessionDataTask?
    
    func showError(msg: String) {
        self.errorMessage = msg
        self.isLoading = false
        self.showError = true
    }
    
    func getTitle() -> String {
        isErrorForSuccess ? "Success" : "Error"
    }
    func cancelApiCalls() {
        apiTask?.cancel()
    }
}
