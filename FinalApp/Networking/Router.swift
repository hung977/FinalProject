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
    
    var baseURL: String {
        return "http://192.168.30.101:8081"
    }
    var URLwithPath: String {
        switch self {
        case .login:
            return "\(baseURL)/api/auth/login"
        case .getProducts, .newProducts, .deleteProducts:
            return "\(baseURL)/api/products"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .newProducts:
            return .post
        case .getProducts:
            return .get
        case .deleteProducts:
            return .delete
        }
    }
    
    var headers: HTTPHeaders {
        let bearerToken = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2YjE0Yjc2Ny1jYTg3LTdhOTgtMTEzYy0zOWY2MjY2YzdmY2MiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJhZG1pbiIsImV4cCI6MTU5NTY2OTIyNCwiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzOTMiLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo0NDM5MyJ9.IMnZi9pcSOQvOVy7tUFzUehETMst8Jex2rII6-jZ3AA"
        
        switch self {
        case .login:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"), HTTPHeader(name: "Accept", value: "*/*")])
        case .getProducts:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"), HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        case .newProducts:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "multipart/form-data"), HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        case .deleteProducts:
            return HTTPHeaders([HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        }
        
    }
    
}
