//
//  File.swift
//  
//
//  Created by Ali Raza on 29/05/2024.
//

import Foundation
import Alamofire


@available(iOS 13.0, *)
class BaseService: NSObject, ObservableObject {
    var params: [String: Any] = [:]
    
    func execute<T: Codable>(stringURL: String, httpMethod: HTTPMethod, completion: @escaping (ParsedResponse<T>?) -> Void) {
        guard let url = URL(string: stringURL) else {
            print("URL not hit: \(stringURL)")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        do {
            if httpMethod == .get {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            } else {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            }
            
            #if DEBUG
            urlRequest.printRequest()
            #endif
            AF.request(urlRequest).responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let jsonResponse = try? JSONDecoder().decode(ServiceResponse<T>.self, from: response.data!) {
                        #if DEBUG
                        print("\n\n\nResponse:------\n\(jsonResponse)\n\n\n")
                        #endif
                        
                        let parsedResponse = ParsedResponse(responseCode: jsonResponse.responseCode, responseDescription: jsonResponse.responseDescription, responsePayload: jsonResponse.responsePayload)
                        completion(parsedResponse)
                    } else {
                        #if DEBUG
                        print(data)
                        #endif
                        completion(nil)
                    }
                case .failure(let error):
                    #if DEBUG
                    print(error)
                    #endif
                    completion(nil)
                    
                }
            }//Request
        } catch {
            #if DEBUG
            print("Error encoding parameters into JSON: \(error)")
            #endif
            completion(nil)
        }
    }
}

