//
//  FlickrPhotosDataController.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 18/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import Foundation
import UIKit

protocol FlickrPhotosListener {
    func didUpdatePhotos()
}

protocol DataControllerProtocol {
    var isFetchingData: Bool { get }
}

class FlickrPhotosDataController: DataControllerProtocol {
    var isFetchingData: Bool = false
    
    var pageNumber: Int = 1
    var searchText: String = ""
    
    var photos: [FlickrPhoto] = [FlickrPhoto]()
    
    var networkService: NetworkManagerProtocol
    var flickrPhotosListener: FlickrPhotosListener?
    
    var imageCache: ImageCache = ImageCache.init()
    
    init(networkService: NetworkManagerProtocol) {
        self.networkService = networkService
    }
    
    func fetchPhotos() {
        guard isFetchingData == false else {
            return
        }
        
        let flickrPhotosRequest = FlickrPhotosRequest.init(pageNumber, searchText: searchText)
        
        isFetchingData = true
        
        print("fetching photos pageNumber: \(pageNumber)")
        networkService.sendRequest(request: flickrPhotosRequest) { (response) in
            switch response {
            case .data(let anyData):
                do {
                    guard let data = anyData as? Data else {
                        break
                    }
                    
                    let flickPhotosResponse = try JSONDecoder.init().decode(FlickPhotosResponse.self, from: data)
                    
                    self.photos.append(contentsOf: flickPhotosResponse.flickPhotosContainer.flickrPhotos)
                    
                    print("total pages \(flickPhotosResponse.flickPhotosContainer.totalPages)")
                    print("fetched photos pageNumber: \(self.pageNumber)")
                    self.pageNumber += 1
                    
                    DispatchQueue.main.async {
                        self.flickrPhotosListener?.didUpdatePhotos()
                    }
                } catch {
                    print(error)
                }
                break
            case .error(let reason):
                    print(reason)
                break
            }
            
            self.isFetchingData = false
        }
        
//        flickrPhotosListener?.didUpdatePhotos()
    }
    
    func resetData() {
        imageCache.clearCache()
        photos.removeAll()
        
        searchText = ""
        pageNumber = 1
        
        flickrPhotosListener?.didUpdatePhotos()
    }
    
    func fetchImage(for flickrPhoto: FlickrPhoto, completion: @escaping (UIImage) -> Void) {
        
        let flickrPhotoRequest = StaticAPIRequest.init(host: "farm\(flickrPhoto.farm).static.flickr.com", path: "/\(flickrPhoto.server)/\(flickrPhoto.id)_\(flickrPhoto.secret).jpg")
        
        do {
            let urlRequest = try URLService.init().makeRequest(request: flickrPhotoRequest, for: networkService)
         
            if let urlString = urlRequest.url?.absoluteString, let uiImage = imageCache.getImage(for: urlString) {
                completion(uiImage)
            } else {
                networkService.sendRequest(request: flickrPhotoRequest) { (response) in
                    switch response {
                    case .data(let data):
                        guard let imageData = data as? Data, let uiImage = UIImage.init(data: imageData) else {
                            return
                        }
                        
                        if let urlString = urlRequest.url?.absoluteString {
                            self.imageCache.storeImage(uiImage, for: urlString)
                        }
                        
                        completion(uiImage)
                        break
                    case .error(let reason):
                        print("Error while fetching Image \(reason)")
                        break
                    }
                }
            }
        } catch {
            print("Error while fetching Image \(error)")
        }
    }
}
