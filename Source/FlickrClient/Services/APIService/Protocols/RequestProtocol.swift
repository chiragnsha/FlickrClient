//
//  RequestProtocol.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 18/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    var host: String { get }
    var path: String { get }
    var queryItems: [String : String]? { get }
}
