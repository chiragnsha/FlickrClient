//
//  FlickPhotosResponse.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 18/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import Foundation

struct FlickPhotosResponse: Decodable {
    var flickPhotosContainer: FlickPhotosContainer
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.flickPhotosContainer = try container.decode(FlickPhotosContainer.self, forKey: .photos)
    }
}

struct FlickPhotosContainer: Decodable {
    var pageNumber: Int
    var totalPages: Int
    var totalPhotos: String
    
    var flickrPhotos: [FlickrPhoto]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case total
        case photo
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.pageNumber = try container.decode(Int.self, forKey: .page)
        self.totalPages = try container.decode(Int.self, forKey: .pages)
        self.totalPhotos = try container.decode(String.self, forKey: .total)
        
        self.flickrPhotos = try container.decode([FlickrPhoto].self, forKey: .photo)
    }
}
