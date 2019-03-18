//
//  NetworkManagerProtocol.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 17/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    func sendRequest(request: RequestProtocol, completion: @escaping (Response) -> Void)
}

protocol FlickrNetworkManagerProtocol: NetworkManagerProtocol {
    var flickr_api_key: String { get }
}
