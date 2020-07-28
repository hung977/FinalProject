//
//  CreateEmployee.swift
//  FinalApp
//
//  Created by TPS on 7/28/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation

public struct CreateEmployee: Codable {
    public var id: String?
    public var code : Int?
    public var traceId : String?
    public var Email : [String]?
    public var Name : [String]?
    public var Password : [String]?
    public var PhoneNumber : [String]?
    public var UserName : [String]?
}
