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
    public var totalItems : Int
    public var totalPages : Int
    public var pageSize : Int
    public var pageIndex : Int
    
}

