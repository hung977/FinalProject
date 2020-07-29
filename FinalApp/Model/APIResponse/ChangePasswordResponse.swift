//
//  ChangePasswordResponse.swift
//  FinalApp
//
//  Created by TPS on 7/29/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation

public struct ChangePasswordResponse: Codable {
    public var Password: [String] = ["PASSWORD_ERROR"]
    public var ConfirmPassword: [String] = ["COFIRM_PASSWORD_ERROR"]
}
