//
//  FlickrPhoto.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 17/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import Foundation

public struct FlickrPhoto: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPublic: Int
    let isFriend: Int
    let isFamily: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case ispublic
        case isfriend
        case isfamily
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.secret = try container.decode(String.self, forKey: .secret)
        self.server = try container.decode(String.self, forKey: .server)
        self.farm = try container.decode(Int.self, forKey: .farm)
        self.title = try container.decode(String.self, forKey: .title)
        
        self.isPublic = try container.decode(Int.self, forKey: .ispublic)
        self.isFriend = try container.decode(Int.self, forKey: .isfriend)
        self.isFamily = try container.decode(Int.self, forKey: .isfamily)
        
//        container.decodeIfPresent(<#T##type: Bool.Type##Bool.Type#>, forKey: <#T##FlickrPhoto.CodingKeys#>)
//        do {
//
//        } catch DecodingError.valueNotFound {
//            print("DecodingError.valueNotFound")
//            throw DecodingError.valueNotFound(<#T##Any.Type#>, <#T##DecodingError.Context#>)
//        } catch let error {
//            print(error)
//            throw error
//        }
    }
}
