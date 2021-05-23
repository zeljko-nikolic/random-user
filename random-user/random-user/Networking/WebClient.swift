//
//  WebClient.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 21.5.21..
//

import UIKit

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

class WebClient {
    
    var baseUrl: String
    
    //MARK: - Init
    required init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    //MARK: - Public
    func load(path: String?, method: RequestMethod, queryParams: JSONDictionary?, bodyParams: Data?, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let url = createRequestURL(path: path, queryParameters: queryParams)
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        if let body = bodyParams {
            request.httpBody = body
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)                
            }
        }
        task.resume()
    }
    
    //MARK: - Private
    private func createRequestURL(path: String?, queryParameters: JSONDictionary?) -> URL? {
        var components: URLComponents?
        if let urlPath = path {
            let correctPath = urlPath.replacingOccurrences(of: " ", with: "%20")
            components = URLComponents(string: "\(baseUrl)\(correctPath)")
        }
        else {
            components = URLComponents(string: "\(baseUrl)")
        }
        
        var queryItems: [URLQueryItem] = []
        if let queryParams = queryParameters {
            if queryParams.count > 0 {
                for key in queryParams.keys {
                    let encodedValue = queryParams[key]
                    var value: String
                    if (encodedValue is [Any]) {
                        for item in encodedValue as! [Any] {
                            let queryItem = URLQueryItem(name: "\(key)[]", value: "\(item)")
                            queryItems.append(queryItem)
                        }
                    } else {
                        value = "\(encodedValue ?? "")"
                        let queryItem = URLQueryItem(name: "\(key)", value: "\(value)")
                        queryItems.append(queryItem)
                    }
                }
                components?.queryItems = queryItems
            }
        }
        return components?.url
    }

}
