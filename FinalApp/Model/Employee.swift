//
//  Employee.swift
//  FinalApp
//
//  Created by TPS on 7/27/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation
public struct EmployeeResponse: Codable {

        public var items : [Employee]
        public var pageIndex : Int
        public var pageSize : Int
        public var totalItems : Int
        public var totalPages : Int
        
}
public struct Employee: Codable {

        public var name : String
        public var username : String
        public var email : String
        public var phoneNumber : String
        public var dateOfBirth : String?
        public var address : String
        public var locked : Bool
        public var role : String
        public var id : String
        
}
