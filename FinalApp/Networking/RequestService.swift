//
//  RequestService.swift
//  FinalApp
//
//  Created by TPS on 7/23/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation
import Alamofire

typealias CompletionHandleJSON = (_ result:Bool, _ json:Any?, _ error:Error?)->Void
typealias CompletionHandleResponse = (_ response: HTTPURLResponse?, _ error: Error)-> Void
class RequestService {
    static var shared = RequestService()
    
    //    func request(router: Router, parameters: [String: Any]?, completion: @escaping CompletionHandleResponse) {
    //        AF.request(router.URLwithPath,
    //                   parameters: parameters,
    //                   encoder: JSONParameterEncoder.default,
    //                   headers: router.headers).response { (response) in
    //                    switch(response.result) {
    //                    case .success(let data):
    //                        print(data!)
    //                    case .failure(let error):
    //                        print(error)
    //                    }
    //        }
    //    }
    
    //    final func uploadImage(router: Router, _ image: UIImage, params: [String: Any]) {
    //        let imgData = image.jpegData(compressionQuality: 0.2)!
    //        _ = AF.upload(multipartFormData: { multipartFormData in
    //            multipartFormData.append(imgData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
    //            for (key, value) in params {
    //                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
    //            }
    //        },
    //        to: router.URLwithPath,
    //        headers: router.headers)
    //        { (result) in
    //            print(result)
    //
    //        }
    //
    //    }
    final func uploadProductImage(router: Router, _ image: UIImage, params: [String: String]) {
        let imgData = image.jpegData(compressionQuality: 0.2)!
        _ = AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to: router.URLwithPath, method: router.method, headers: router.headers, requestModifier: { (result) in
            print(result)
        })
        
    }
    
    func AFRequestWithRawData<T: Codable>(router: Router, parameters: [String:String]?, objectType: T.Type, completion: @escaping CompletionHandleJSON) {
        AF.request(router.URLwithPath,
                   method: router.method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: router.headers).response { (response) in
                    // print("Body: \(parameters)")
                    switch(response.result) {
                    case .success(let data):
                        do {
                            let json = try JSONDecoder.init().decode(objectType.self, from: data!)
                            completion(true, json, nil)
                        } catch {
                            completion(false, data, nil)
                        }
                    case .failure(let err):
                        completion(false, nil, err)
                    }
        }
    }
}

