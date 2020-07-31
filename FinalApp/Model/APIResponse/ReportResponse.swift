//
//  ReportResponse.swift
//  FinalApp
//
//  Created by TPS on 7/31/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation

public struct ReportResponse : Codable {
    
    public var product : Product
    public var repoProductAmount : Int
    public var repoProductPrice : Double
    public var importProductAmount : Int
    public var importProductPrice : Double
    public var saleProductAmount : Int
    public var saleProductPrice : Double
    public var revenue : Double
    public var remainingProductAmount : Int
    public var profit : Double
    
}

