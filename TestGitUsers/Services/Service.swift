//
//  Service.swift
//  TestGitUsers
//
//  Created by Ira Golubovich on 2/19/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import Foundation


class Service {
    
    static let shared = Service()
    
    func getData(method: String, since: Int?, completion: @escaping (_ data: Data) -> Void) {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "http"
        urlComponents.host = "api.github.com"
        urlComponents.path = "/\(method)"
        if let since = since{
        urlComponents.query = "since=\(since)"
        }
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            completion(data)
            
        }.resume()
    }
}
