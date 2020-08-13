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
    case getReport
    case getDistributor
    case editDistributor
    case addDistributor
    case deleteDistributor
    case getImportReceipt
    
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
        case .getReport:
            return "\(baseURL)/api/Reports"
        case .getDistributor, .editDistributor, .addDistributor, .deleteDistributor:
            return "\(baseURL)/api/distributors"
        case .getImportReceipt:
            return "\(baseURL)/api/ImportReceipts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .newProducts, .createEmployee, .postSaleReceipt, .addDistributor:
            return .post
        case .getProducts, .getEmployee, .getReport, .getDistributor, .getImportReceipt:
            return .get
        case .deleteProducts, .deleteEmployee, .deleteDistributor:
            return .delete
        case .editEmployee, .changePassword, .editDistributor:
            return .put
        }
    }
    
    var headers: HTTPHeaders {
        let bearerToken = "Bearer \(LoginViewController.token)"
        
        switch self {
        case .login:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"), HTTPHeader(name: "Accept", value: "*/*")])
        case .getProducts, .getEmployee, .getDistributor, .getImportReceipt:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"), HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        case .newProducts, .addDistributor, .editDistributor:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "multipart/form-data"), HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        case .deleteProducts, .deleteEmployee, .getReport, .deleteDistributor:
            return HTTPHeaders([HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        case .createEmployee, .editEmployee, .postSaleReceipt, .changePassword:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json-patch+json"), HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        }   
        
    }
}
