//
//  FlickrCollectionViewDataSource.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 17/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import UIKit

protocol FlickrCollectionProtocol {
    var photosDataController: FlickrPhotosDataController { get }
}

class FlickrCollectionViewDataSource<T: UICollectionViewCell & FlickrViewCellProtocol>: NSObject, UICollectionViewDataSource, FlickrCollectionProtocol, UICollectionViewDelegateFlowLayout {
    var photosDataController: FlickrPhotosDataController
    
    init(photosDataController: FlickrPhotosDataController) {
        self.photosDataController = photosDataController
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        ///load empty view
        if photosDataController.photos.count == 0 {
            if let emptyCV = collectionView as? EmptyView {
                collectionView.backgroundView = emptyCV.emptyBackgroundView
            }
            
            return 0
        } else {
            collectionView.backgroundView = nil
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosDataController.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(T.self), for: indexPath)
        
        
        print("cell for at: \(indexPath.row)")
        if((photosDataController.photos.count - indexPath.row) < 5
            && photosDataController.isFetchingData == false) {
            
            
            photosDataController.fetchPhotos()
        }
        
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSpacing = CGFloat(0.0)
        
        let numberOfCells = CGFloat(3)
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            cellSpacing = flowLayout.minimumInteritemSpacing
        }
        
        //let itemWidth = ceil((collectionView.frame.width / (numberOfCells)) - ((numberOfCells - 1) * cellSpacing))
        
        let itemWidth = floor((collectionView.frame.width - ((numberOfCells - 1) * cellSpacing)) / numberOfCells)
        
        return CGSize.init(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        print("willDisplay for at: \(indexPath.row)")
        
        if let flickrCell = cell as? T {
            guard let photoIndex = photosDataController.photos.index(photosDataController.photos.startIndex, offsetBy: indexPath.row, limitedBy: photosDataController.photos.endIndex) else {
                
                return
            }
            
            let flickrPhoto = photosDataController.photos[photoIndex]
            
            photosDataController.fetchImage(for: flickrPhoto) { (flickrImage) in
                DispatchQueue.main.async {
                    if indexPath == collectionView.indexPath(for: cell) {
                        flickrCell.setImage(flickrImage)
                    }
                }
            }
            
            /*
            let flickrPhotoRequest = StaticAPIRequest.init(host: "farm\(flickrPhoto.farm).static.flickr.com", path: "/\(flickrPhoto.server)/\(flickrPhoto.id)_\(flickrPhoto.secret).jpg")
            
//            photosDataController.fetchImage(for: flick)
            photosDataController.networkService.sendRequest(request: flickrPhotoRequest) { (response) in
                switch response {
                case .data(let anyData):
                    guard let imageData = anyData as? Data,
                        let uiImage = UIImage.init(data: imageData) else {
                            return
                    }
                    
                    DispatchQueue.main.async {
                        if indexPath == collectionView.indexPath(for: cell) {
                            flickrCell.setImage(uiImage)
                        }
                    }
                    
                    break
                case .error(let reason):
                    print(reason)
                    break
                }
            }
 */
        }
    }
    
}

