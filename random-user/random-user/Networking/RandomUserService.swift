//
//  RandomUserService.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 21.5.21..
//

import Foundation

class RandomUserService {
    
    private var client: WebClient
    
    init(client: WebClient = WebClient(baseUrl: Constants.randomUserBaseUrl)) {
        self.client = client
    }
    
    func getRandomUsers(numberOfUsers: Int, page: Int, completion: @escaping (Result<RandomUserResponse, Error>) -> Void) {
        var query = JSONDictionary()
        query.updateValue(numberOfUsers, forKey: Constants.resultsQuery)
        query.updateValue(page, forKey: Constants.pageQuery)
        query.updateValue("name,email,dob,picture,nat,login", forKey: Constants.includeQuery)
        
        client.load(path: nil, method: .get, queryParams: query, bodyParams: nil) { data, urlResponse, error in
            if let responseError = error {
                completion(.failure(responseError))
                return
            }
            
            guard let result = data else {
                let error = NSError(domain:Constants.randomUserBaseUrl, code:-1, userInfo:[NSLocalizedDescriptionKey : "No data."])
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                decoder.dateDecodingStrategy = .formatted(formatter)
                let randomUserResponse = try decoder.decode(RandomUserResponse.self, from: result)
                completion(.success(randomUserResponse))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}
