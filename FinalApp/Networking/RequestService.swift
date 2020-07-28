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
    typealias CompletionHandleResponse = (_ response: AFDataResponse<Data?>?, _ error: Error?)-> Void
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
        
        public class func callsendImageAPIEditProduct(for id: String, param:[String: Any],arrImage:[UIImage],imageKey:String, withblock:@escaping (_ response: AnyObject?)->Void){
            
            let bearerToken = "Bearer \(LoginViewController.token)"
            let baseURL = "http://192.168.30.101:8081/api/products/\(id)"
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
              method: .put,
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
        
        func AFRequestLogin<T: Codable>(router: Router, params: [String:String]?, objectType: T.Type, completion: @escaping CompletionHandleJSON) {
            AF.request(router.URLwithPath,
                       method: router.method,
                       parameters: params,
                       encoder: JSONParameterEncoder.default,
                       headers: router.headers).response { (response) in
                        switch(response.result) {
                        case .success(let data):
                            completion(true,data,nil)
                            
                        case .failure(let err):
                            completion(false, nil, err)
                        }
            }
        }
        func AFRequestProduct<T: Codable>(router: Router, params: [String:String]?, objectType: T.Type, completion: @escaping CompletionHandleJSON) {
            AF.request(router.URLwithPath,
                       method: router.method,
                       parameters: params,
                       encoding: URLEncoding.default,
                       headers: router.headers).response { (response) in
                        switch(response.result) {
                        case .success(let data):
                            completion(true,data,nil)
                            
                        case .failure(let err):
                            completion(false, nil, err)
                        }
            }
        }
        func AFRequestCreateEmployee(router: Router, params: [String:String], completion: @escaping CompletionHandleJSON) {
            AF.request(router.URLwithPath,
                       method: router.method,
                       parameters: params,
                       encoder: JSONParameterEncoder.default,
                       headers: router.headers).response { (response) in
                        switch (response.result) {
                        case .success(let data):
                            completion(true, data, nil)
                        case .failure(let err):
                            completion(false, nil, err)
                        }
            }
        }
        func AFRequestEditEmployee(router: Router, id: String, params: [String:String], completion: @escaping CompletionHandleResponse) {
            
            let urlWithId = "\(router.URLwithPath)/\(id)"
            AF.request(urlWithId,
                       method: router.method,
                       parameters: params,
                       encoder: JSONParameterEncoder.default,
                       headers: router.headers).response { (response) in
                        switch(response.result) {
                        case .success:
                            completion(response, nil)
                        case .failure(let err):
                            completion(nil, err)
                        }
            }
        }
    }
    
