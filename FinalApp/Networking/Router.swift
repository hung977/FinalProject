//
//  Router.swift
//  FinalApp
//
//  Created by TPS on 7/23/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation
import Alamofire


enum Router {
    case login
    case getProducts
    case newProducts
    case deleteProducts
    case getEmployee
    case createEmployee
    case editEmployee
    
    var baseURL: String {
        return "http://192.168.30.101:8081"
    }
    var URLwithPath: String {
        switch self {
        case .login:
            return "\(baseURL)/api/auth/login"
        case .getProducts, .newProducts, .deleteProducts:
            return "\(baseURL)/api/products"
        case .getEmployee, .createEmployee, .editEmployee:
            return "\(baseURL)/api/users"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .newProducts, .createEmployee:
            return .post
        case .getProducts, .getEmployee:
            return .get
        case .deleteProducts:
            return .delete
        case .editEmployee:
            return .put
        }
    }
    
    var headers: HTTPHeaders {
        let bearerToken = "Bearer \(LoginViewController.token)"
        
        switch self {
        case .login:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"), HTTPHeader(name: "Accept", value: "*/*")])
        case .getProducts, .getEmployee:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"), HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        case .newProducts:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "multipart/form-data"), HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        case .deleteProducts:
            return HTTPHeaders([HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        case .createEmployee:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json-patch+json"), HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        case .editEmployee:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json-patch+json"), HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        }
        
    }
}
