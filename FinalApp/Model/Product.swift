//
//  Product.swift
//  FinalApp
//
//  Created by TPS on 7/27/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation
public struct ProductResponse: Codable {

        public var items : [Product]
        public var totalItems : Int
        public var totalPages : Int
        public var pageSize : Int
        public var pageIndex : Int
        
}
public struct Product: Codable {

    public var name: String
    public var price: Double
    public var amount: Int
    public var image: String
    public var id: String
        
}
