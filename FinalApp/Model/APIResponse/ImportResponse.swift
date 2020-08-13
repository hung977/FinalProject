//
//  ImportResponse.swift
//  FinalApp
//
//  Created by TPS on 8/13/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation
public struct ImportResponse: Codable {

    public var items : [Import]
    public var totalItems : Int
    public var totalPages : Int
    public var pageSize : Int
    public var pageIndex : Int
        
}
