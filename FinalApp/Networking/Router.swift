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
    
    var baseURL: String {
        return "http://192.168.30.101:8081"
    }
    var URLwithPath: String {
        switch self {
        case .login:
            return "\(baseURL)/api/auth/login"
        case .getProducts, .newProducts:
            return "\(baseURL)/api/products"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .newProducts:
            return .post
        case .getProducts:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        let bearerToken = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1NGEyY2E5Ni0wZWJhLWYzNDYtMTQ5Zi0zOWY2MjY2YzdmYTMiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJhZG1pbiIsImV4cCI6MTU5NTU3NDUyOCwiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzOTMiLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo0NDM5MyJ9.uIgbLjOS6Uwz73AkoaDE89uvbytE25X6cadRrXrH6kE"
        
        switch self {
        case .login:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"), HTTPHeader(name: "Accept", value: "*/*")])
        case .getProducts:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"), HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        case .newProducts:
            return HTTPHeaders([HTTPHeader(name: "Content-Type", value: "multipart/form-data"), HTTPHeader(name: "Accept", value: "*/*"), HTTPHeader(name: "Authorization", value: bearerToken)])
        }
        
    }
    
}
