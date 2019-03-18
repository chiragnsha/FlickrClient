//
//  FlickrSearchViewController.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 17/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import UIKit

class FlickrSearchViewController: UIViewController {
    var flickrCollectionView: FlickCollectionView<FlickrCollectionViewCell>
    
    var networkService: FlickrNetworkManagerProtocol
    
    var searchController = UISearchController.init(searchResultsController: nil)
    
    var flickrPhotosDataController: FlickrPhotosDataController
    var flickrPhotosDataSource: FlickrCollectionViewDataSource<FlickrCollectionViewCell>
    
    init(_ networkService: FlickrNetworkManagerProtocol) {
        self.networkService = networkService
        
        self.flickrPhotosDataController = FlickrPhotosDataController.init(networkService: self.networkService)
        self.flickrPhotosDataSource = FlickrCollectionViewDataSource.init(photosDataController: self.flickrPhotosDataController)
        
        
        let flickrCollectionViewLayout = UICollectionViewFlowLayout.init()
        flickrCollectionViewLayout.itemSize = CGSize.init(width: 100, height: 100)
        
        flickrCollectionView = FlickCollectionView.init(frame: CGRect.zero, collectionViewLayout: flickrCollectionViewLayout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Flickr Search"
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        self.edgesForExtendedLayout = []
        
        setupView()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func setupView()  {
        self.view.backgroundColor = UIColor.white
        
        setupCollectionView()
        setupSearchController()
    }

    private func setupCollectionView() {
        flickrCollectionView.translatesAutoresizingMaskIntoConstraints = false
        flickrCollectionView.dataSource = self.flickrPhotosDataSource
        flickrCollectionView.delegate = self.flickrPhotosDataSource
        
        self.view.addSubview(flickrCollectionView)
        
        if #available(iOS 11.0, *) {
            flickrCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            flickrCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            flickrCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            flickrCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            flickrCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            flickrCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            flickrCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            flickrCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }
    }
    
    private func setupSearchController() {
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Flicker Images"
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.searchController?.searchBar.backgroundColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        
        self.definesPresentationContext = true
        self.searchController.searchBar.delegate = self
    }
    
    private func setupDelegates() {
        self.flickrPhotosDataController.flickrPhotosListener = self
    }
}

extension FlickrSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        
        flickrPhotosDataController.resetData()
        
        flickrPhotosDataController.searchText = searchText
        flickrPhotosDataController.fetchPhotos()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        /// data provider
        //flickrPhotosDataController.resetData()
    }
}

extension FlickrSearchViewController: FlickrPhotosListener {
    func didUpdatePhotos() {
//        let invalidationContext = UICollectionViewFlowLayoutInvalidationContext.init()
//        
//        invalidationContext.invalidateFlowLayoutDelegateMetrics = true
//        
//        flickrCollectionView.collectionViewLayout.invalidateLayout(with: invalidationContext)
        
        flickrCollectionView.reloadData()
    }
}
