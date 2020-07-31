//
//  NetworkManager.swift
//  FinalApp
//
//  Created by TPS on 7/31/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {

    var manager: Session?

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(5)
        configuration.timeoutIntervalForResource = TimeInterval(5)
        manager = Alamofire.Session(configuration: configuration, startRequestsImmediately: true)
    }
}
