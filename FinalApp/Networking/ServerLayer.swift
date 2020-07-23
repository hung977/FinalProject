//
//  ServerLayer.swift
//  FinalApp
//
//  Created by TPS on 7/23/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation
import Alamofire

class ServerLayer {
    typealias CompletionHandleData = (_ data:Data?, _ response: URLResponse?, _ error:Error?)->Void
    static var shared = ServerLayer()
    
    func request(router: Router, completion: @escaping CompletionHandleData) {
        var components = URLComponents()
        components.host = router.host
        components.path = router.path
        guard let url = components.url else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: router.parameters as Any)
        } catch let error {
            print("Error: \(error)")
        }
        let session = URLSession(configuration: .default)
        print(urlRequest.allHTTPHeaderFields as Any)
        print(String(data: urlRequest.httpBody!, encoding: .utf8) as Any)
        print(urlRequest.url as Any)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                completion(nil, nil, err)
                print(err.localizedDescription)
                return
            }
            guard response != nil, let data = data else { return }
            completion(data, response, nil)
        }
        dataTask.resume()
        
        
        
        
    }
}
