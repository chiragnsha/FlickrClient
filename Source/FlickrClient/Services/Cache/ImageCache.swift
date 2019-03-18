//
//  ImageCache.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 18/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import Foundation
import UIKit

protocol ImageCacheProtocol {
    func clearCache()
}

class ImageCache: ImageCacheProtocol {
    private var cache: NSCache = NSCache<NSString, UIImage>()
    
    func storeImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: NSString.init(string: key))
    }
    
    func getImage(for key: String) -> UIImage? {
        return cache.object(forKey: NSString.init(string: key))
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
