//
//  Networking.swift
//  Vidzam
//
//  Created by Arpit Patel on 2019-01-13.
//  Copyright © 2019 Zapps Inc. All rights reserved.
//

import Foundation

typealias NetworkCompletionHandler = (Data?, URLResponse?, Error?) -> Void

class Networking {
    
    func submitPost(urlString: String,
              body: [String: Any] = [:],
              headers: [String: String] = [:],
              errorHandler: @escaping (String) -> (Void),
              successHandler: @escaping (String) -> (Void)) {
        
        let completionHandler: NetworkCompletionHandler = { (data, urlResponse, error) in
            if let error = error {
                errorHandler(error.localizedDescription)
                return
            }
            
            if !self.isSuccessCode(urlResponse) {
                errorHandler(urlResponse.debugDescription)
                return
            } else {
                let dataDict = String(data: data!, encoding: String.Encoding.utf8) as String!
                successHandler(dataDict!)
                return
            }
        }
        
        guard let url = URL(string: urlString) else {
            return errorHandler("Unable to create URL from given string")
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 90
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.allHTTPHeaderFields?["Content-Type"] = "application/json"
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(body) else {
            return errorHandler("Cannot encode given object into Data")
        }
        
        request.httpBody = data
        URLSession.shared
            .uploadTask(with: request,
                        from: data,
                        completionHandler: completionHandler)
            .resume()
    }
    
    private func isSuccessCode(_ statusCode: Int) -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
    
    private func isSuccessCode(_ response: URLResponse?) -> Bool {
        guard let urlResponse = response as? HTTPURLResponse else {
            return false
        }
        return isSuccessCode(urlResponse.statusCode)
    }

}
