//
//  APIRequest.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 18/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import Foundation

class StaticAPIRequest: RequestProtocol {
    var host: String
    
    var path: String
    
    var queryItems: [String : String]?
    
    init(host: String, path: String) {
        self.host = host
        self.path = path
    }
}
