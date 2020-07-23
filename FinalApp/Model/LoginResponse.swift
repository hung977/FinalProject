//
//  Login.swift
//  FinalApp
//
//  Created by TPS on 7/23/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation

public struct LoginResponse: Codable {

        public var accessToken : String
        public var expiresIn : Int
        public var profile : Profile
        
}
public struct Profile: Codable {

        public var address : String
        public var dateOfBirth : String?
        public var email : String
        public var id : String
        public var name : String
        public var phoneNumber : String
        public var role : String
        public var username : String
        
}
