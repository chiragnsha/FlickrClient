//
//  FlickrPhotosDataController.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 18/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import Foundation

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
        photos.removeAll()
        
        searchText = ""
        pageNumber = 1
        
        flickrPhotosListener?.didUpdatePhotos()
    }
}
