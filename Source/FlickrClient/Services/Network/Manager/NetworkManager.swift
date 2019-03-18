//
//  NetworkManager.swift
//  FlickrClient
//
//  Created by Chirag N Shah on 17/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import UIKit

public enum NetworkManagerError: Error {
    case InvalidURL
}

class URLService {
    func makeRequest(request: RequestProtocol, for manager: NetworkManagerProtocol) throws -> URLRequest {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        
        if request is FlickrRequestProtocol {
            urlComponents.host = "api.flickr.com"
        } else {
            urlComponents.host = request.host
        }
        
        urlComponents.path = request.path
        
        if let queryItems = request.queryItems {
            let urlQueryItems = queryItems.map({ (queryItem) -> URLQueryItem in
                return URLQueryItem.init(name: queryItem.key, value: queryItem.value)
            })
            
            if urlComponents.queryItems == nil {
                urlComponents.queryItems = urlQueryItems
            } else {
                urlComponents.queryItems?.append(contentsOf: urlQueryItems)
            }
        }
        
        if request is FlickrRequestProtocol {
            if let flickrNetworkManager = manager as? FlickrNetworkManagerProtocol {
                let urlQueryItem = URLQueryItem.init(name: "api_key", value: flickrNetworkManager.flickr_api_key)
                
                if urlComponents.queryItems == nil {
                    urlComponents.queryItems = [urlQueryItem]
                } else {
                    urlComponents.queryItems?.append(urlQueryItem)
                }    
            }
        }
        
        guard let url = urlComponents.url else {
            throw NetworkManagerError.InvalidURL
        }
        
        return URLRequest.init(url: url)
    }
}

public enum Response {
    case data(Any)
    case error(String)
}

class NetworkManager: NSObject, FlickrNetworkManagerProtocol {
    var flickr_api_key: String
    var urlService: URLService = URLService.init()
    
    var urlSession = URLSession.init(configuration: .default)
    
    init(flickrApiKey: String) {
        self.flickr_api_key = flickrApiKey
        
        super.init()
    }
    
    func sendRequest(request: RequestProtocol, completion: @escaping (Response) -> Void) {
        do {        
            let urlRequest = try urlService.makeRequest(request: request, for: self)
            
            let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in

                guard let response = response as? HTTPURLResponse else {
                    completion(Response.error("error"))
                    return
                }
                
                if response.statusCode == 200 {
                    completion(Response.data(data))
                } else {
                    completion(Response.error("error"))
                }
            }
            
            dataTask.resume()
        } catch {
            completion(Response.error("error"))
        }
    }
}
