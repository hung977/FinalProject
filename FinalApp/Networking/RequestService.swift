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
    typealias CompletionHandleResponseAndData = (_ data: Data?, _ response: AFDataResponse<Data?>?, _ error: Error?)-> Void
    class RequestService {
        static var shared = RequestService()
        func request(router: Router, id: String, withblock:@escaping (_ response: AFDataResponse<Data?>?, _ error: Error?)->Void) {
            let urlWithId = "\(router.URLwithPath)/\(id)"
            AF.request(urlWithId,
                       method: router.method,
                       headers: router.headers).response { (response) in
                        switch(response.result) {
                        case .success:
                            withblock(response, nil)
                        case .failure(let error):
                            withblock(nil, error)
                        }
            }
            
        }
        func AFRequestChangePassWord(router: Router, id: String, params: [String:String], completion:@escaping CompletionHandleResponseAndData) {
            let urlWithId = "\(router.URLwithPath)/\(id)/password"
            AF.request(urlWithId,
                       method: router.method,
                       parameters: params,
                       encoder: JSONParameterEncoder.default,
                       headers: router.headers).response { (response) in
                        
                        switch(response.result) {
                        case .success(let data):
                            completion(data,response, nil)
                        case .failure(let error):
                            completion(nil,response, error)
                        }
            }
        }
        public class func callsendImageAPIEditEmployee(for id: String, param:[String: Any],arrImage:[UIImage],imageKey:String, withblock:@escaping (_ response: AFDataResponse<Data?>?, _ error:Error?)->Void){
            
            let bearerToken = "Bearer \(LoginViewController.token)"
            let baseURL = "http://192.168.30.101:8081/api/users/\(id)"
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
                switch (response.result) {
                case .success:
                    withblock(response, nil)
                case .failure(let error):
                    withblock(nil, error)
                }
            }
        }
        public class func callsendImageAPICreateEmployee(param:[String: Any],arrImage:[UIImage],imageKey:String, completion: @escaping CompletionHandleJSON){
            
            let bearerToken = "Bearer \(LoginViewController.token)"
            let baseURL = "http://192.168.30.101:8081/api/users"
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
                switch (response.result) {
                case .success(let data):
                    completion(true, data, nil)
                case .failure(let err):
                    completion(false, nil, err)
                }
            }
        }
        
        
        public class func callsendImageAPI(param:[String: Any],arrImage:[UIImage],imageKey:String, withblock:@escaping (_ response: AFDataResponse<Data?>?, _ data:Data?, _ error: Error?)->Void){
            
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
                switch (response.result) {
                case .success(let data):
                    withblock(response, data, nil)
                case .failure(let error):
                    withblock(response, nil, error)
                }
            }
        }
        func AFRequestEditDistributor(for id: String, route: Router, param: [String:Any], withblock:@escaping (_ response: AFDataResponse<Data?>?, _ data:Data?, _ error: Error?)->Void) {
            let bearerToken = "Bearer \(LoginViewController.token)"
            let baseURL = "\(route.URLwithPath)/\(id)"
            let headers: HTTPHeaders
            headers = ["Content-type": "multipart/form-data",
                       "Content-Disposition" : "form-data",
                       "Authorization" : bearerToken]
            AF.upload(multipartFormData: { (multipart) in
                for (key, value) in param {
                    multipart.append((value as! String).data(using: .utf8)!, withName: key)
                }
            }, to: baseURL, usingThreshold: UInt64.init(),
               method: route.method,
               headers: headers).response { (response) in
                switch (response.result) {
                case .success(let data):
                    withblock(response, data, nil)
                case .failure(let error):
                    withblock(response, nil, error)
                }
            }
        }
        func AFRequestAddDistributor(route: Router, param: [String:Any], withblock:@escaping (_ response: AFDataResponse<Data?>?, _ data:Data?, _ error: Error?)->Void) {
            let bearerToken = "Bearer \(LoginViewController.token)"
            let headers: HTTPHeaders
            headers = ["Content-type": "multipart/form-data",
                       "Content-Disposition" : "form-data",
                       "Authorization" : bearerToken]
            AF.upload(multipartFormData: { (multipart) in
                for (key, value) in param {
                    multipart.append((value as! String).data(using: .utf8)!, withName: key)
                }
            }, to: route.URLwithPath, usingThreshold: UInt64.init(),
               method: route.method,
               headers: headers).response { (response) in
                switch (response.result) {
                case .success(let data):
                    withblock(response, data, nil)
                case .failure(let error):
                    withblock(response, nil, error)
                }
            }
        }
        
        public class func callsendImageAPIEditProduct(for id: String, param:[String: Any],arrImage:[UIImage],imageKey:String, withblock:@escaping (_ response: AFDataResponse<Data?>?, _ data:Data?, _ error: Error?)->Void){
            
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
                switch (response.result) {
                case .success(let data):
                    withblock(response, data, nil)
                case .failure(let error):
                    withblock(response, nil, error)
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
        func AFRequestPostReceipt(router: Router, params: [String: Any], completion: @escaping CompletionHandleResponseAndData) {
            AF.request(router.URLwithPath,
                       method: router.method,
                       parameters: params,
                       encoding: JSONEncoding.default,
                       headers: router.headers).response { (response) in
                        switch(response.result) {
                        case .success(let data):
                            completion(data, response, nil)
                        case .failure(let error):
                            completion(nil,response, error)
                        }
            }
        }
        
        func AFRequestReport(router: Router, from: String, to: String, completion: @escaping CompletionHandleResponseAndData) {
            let urlWithId = "\(router.URLwithPath)?from=\(from)&to=\(to)"
            AF.request(urlWithId,
                       method: router.method,
                       encoding: JSONEncoding.default,
                       headers: router.headers).response { (response) in
                        switch(response.result) {
                        case .success(let data):
                            completion(data, response, nil)
                        case .failure(let error):
                            completion(nil,response, error)
                        }
            }
        }
    }
    
