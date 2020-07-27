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

