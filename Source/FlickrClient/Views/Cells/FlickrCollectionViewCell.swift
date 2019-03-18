//
//  FlickrCollectionViewCell.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 17/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import UIKit

protocol FlickrViewCellProtocol {
    func setImage(at location: String)
    func setImage(_ uiImage: UIImage)
}

class FlickrCollectionViewCell: UICollectionViewCell {
    
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    var imageView: UIImageView
    
    override init(frame: CGRect) {
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        
        super.init(frame: frame)
        
        self.contentView.addSubview(imageView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint.init(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        activityIndicator.startAnimating()
        imageView.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FlickrCollectionViewCell: FlickrViewCellProtocol {
    func setImage(at location: String) {
        self.activityIndicator.stopAnimating()
        self.imageView.image = UIImage.init(contentsOfFile: location)
    }
    
    func setImage(_ uiImage: UIImage) {
        self.activityIndicator.stopAnimating()
        self.imageView.image = uiImage
    }
}
