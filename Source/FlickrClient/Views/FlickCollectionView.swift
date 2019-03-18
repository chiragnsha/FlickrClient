//
//  FlickCollectionView.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 17/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import UIKit

protocol EmptyView where Self: UICollectionView {
    var emptyBackgroundView: UIView { get }
}

class FlickCollectionView<T: UICollectionViewCell & FlickrViewCellProtocol>: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.alwaysBounceVertical = true
        self.backgroundColor = UIColor.white
        
        self.register(T.self, forCellWithReuseIdentifier: NSStringFromClass(T.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FlickCollectionView: EmptyView {
    var emptyBackgroundView: UIView {
        let emptyBackgroundView =  UIView.init(frame: CGRect.zero)
        
        let label = UILabel.init(frame: CGRect.zero)
        
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.textColor = UIColor.lightGray
        label.text = "Enter text and click on search button"
        label.textAlignment = .center
//        label.preferredMaxLayoutWidth = self.frame.width
        label.translatesAutoresizingMaskIntoConstraints = false
        
        emptyBackgroundView.addSubview(label)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: label, attribute: .centerX, relatedBy: .equal, toItem: emptyBackgroundView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint.init(item: label, attribute: .top, relatedBy: .equal, toItem: emptyBackgroundView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint.init(item: label, attribute: .centerY, relatedBy: .equal, toItem: emptyBackgroundView, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint.init(item: label, attribute: .left, relatedBy: .equal, toItem: emptyBackgroundView, attribute: .left, multiplier: 1.0, constant: 0.0)
            ])
        
        return emptyBackgroundView
    }
    
    
}
