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
    case deleteEmployee
    case postSaleReceipt
    case changePassword
    
    var baseURL: String {
        return "http://192.168.30.101:8081"
    }
    var URLwithPath: String {
        switch self {
        case .login:
            return "\(baseURL)/api/auth/login"
        case .getProducts, .newProducts, .deleteProducts:
            return "\(baseURL)/api/products"
        case .getEmployee, .createEmployee, .editEmployee, .deleteEmployee, .changePassword:
            return "\(baseURL)/api/users"
        case .postSaleReceipt:
            return "\(baseURL)/api/SaleReceipts"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .newProducts, .createEmployee, .postSaleReceipt:
            return .post
        case .getProducts, .getEmployee:
            return .get
        case .deleteProducts, .deleteEmployee:
            return .delete
        case .editEmployee, .changePassword:
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
        case .deleteProducts, .deleteEmployee:
            return HTTPHeaders([HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        case .createEmployee, .editEmployee, .postSaleReceipt, .changePassword:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json-patch+json"), HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        }
        
    }
}
