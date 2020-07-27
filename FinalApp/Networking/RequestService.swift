//
//  RequestService.swift
//  FinalApp
//
//  Created by TPS on 7/23/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation
import Alamofire

typealias CompletionHandleJSON = (_ result:Bool, _ data:Data?, _ error:Error?)->Void
typealias CompletionHandleResponse = (_ response: HTTPURLResponse?, _ error: Error)-> Void
class RequestService {
    static var shared = RequestService()
    func request(router: Router, id: String, withblock:@escaping (_ response: AnyObject?)->Void) {
        let urlWithId = "\(router.URLwithPath)/\(id)"
        AF.request(urlWithId,
                   method: router.method,
                   headers: router.headers).response { (response) in
                    debugPrint(response)
        }
        
    }
    
    public class func callsendImageAPI(param:[String: Any],arrImage:[UIImage],imageKey:String, withblock:@escaping (_ response: AnyObject?)->Void){
        
        let bearerToken = "Bearer \(LoginViewController.token)"
        let baseURL = "http://192.168.30.101:8081/api/products"
        let headers: HTTPHeaders
        headers = ["Content-type": "multipart/form-data",
                   "Content-Disposition" : "form-data",
                   "Authorization" : bearerToken]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            
            for img in arrImage {
                guard let imgData = img.jpegData(compressionQuality: 1) else { return }
                multipartFormData.append(imgData, withName: imageKey, fileName: String(NSDate().timeIntervalSince1970) + ".jpeg", mimeType: "image/jpeg")
            }
            
            
        },to: baseURL, usingThreshold: UInt64.init(),
          method: .post,
          headers: headers).response{ response in
            
            if(response.error == nil){
                do{
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print(parsedData)
                    }
                }catch{
                    print("error message")
                }
            }else{
                print(response.error?.localizedDescription ?? "___error___")
            }
        }
    }
    
    func AFRequestWithRawData<T: Codable>(router: Router, parameters: [String:String]?, objectType: T.Type, completion: @escaping CompletionHandleJSON) {
        AF.request(router.URLwithPath,
                   method: router.method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: router.headers).response { (response) in
                    // print("Body: \(parameters)")
                    switch(response.result) {
                    case .success(let data):
                        completion(true,data,nil)
                        
                    case .failure(let err):
                        completion(false, nil, err)
                    }
        }
    }
}

