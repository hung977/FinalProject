//
//  Import.swift
//  FinalApp
//
//  Created by TPS on 8/13/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation
public struct Import: Codable {
    
    public var distributor : String
    public var user : String
    public var dateTime : String
    public var totalPrice : Double
    public var importReceiptDetails : [ImportReceiptDetail]?
    public var id : String
    
    
    
}
