//
//  DistributorResponse.swift
//  FinalApp
//
//  Created by TPS on 8/11/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation

public struct DistributorResponse: Codable {
    
    public var items : [Distributor]
    public var totalItems : Int
    public var totalPages : Int
    public var pageSize : Int
    public var pageIndex : Int
    
}
