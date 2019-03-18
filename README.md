# FlickrClient
FlickrClient for iOS

## About

A simple iOS Client app to search images on Flickr.

## Source Abstract

1. FlickSeachViewController loads images in FlickrCollectionView via DataController.

2.  DataController uses NetworkManager.
3. DataController parses DataResponse (should offload this to DataParser)
4. DataController notifies FlickSeachViewController with Response.
5. FlickSeachViewController updates FlickrCollectionView.
6. FlickrCollectionViewCell loads images via NetworkManager.

## Things To Do

1. ImageCache
2. Cancel URLRequest for cells leaving view



