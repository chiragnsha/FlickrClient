//
//  FlickrPhotosRequest.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 18/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import Foundation

public enum FlickrAPIType {
    case photos
    
}

protocol FlickrRequestProtocol {
//    var host: String { get }
//
//    var path: String
//    var queryItems: [String : String]?
    
}

struct FlickrPhotosRequest: FlickrRequestProtocol & RequestProtocol {
    var host: String {
        return ""
    }
    
    var path: String
    
    var queryItems: [String : String]?

    ///cancellable
    //    var task: URLSessionTask?
    
    init(_ pageNumber: Int, searchText: String) {
        self.path = "/services/rest/"
        
        let queryItems = ["method": "flickr.photos.search",
                          "format": "json",
                          "nojsoncallback": "1",
                          "safe_search": "1",
                          "text": searchText,
                          "page": String(pageNumber)]
        

        self.queryItems = queryItems
    }
}
