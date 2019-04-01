//
//  FlickrAPITest.swift
//  FlickrClientTests
//
//  Created by Chirag N Shah on 31/03/19.
//  Copyright © 2019 Chirag N Shah. All rights reserved.
//

import XCTest
@testable import FlickrClient

class FlickrAPITest: XCTestCase {
    private var flikrPhotos: [FlickrPhoto]?
    
    private var flickPhotoSampleJSON = "{\r\n\"id\": \"23451156376\",\r\n\"owner\": \"28017113@N08\",\r\n\"secret\": \"8983a8ebc7\",\r\n\"server\": \"578\",\r\n\"farm\": 1,\r\n\"title\": \"Merry Christmas!\",\r\n\"ispublic\": 1,\r\n\"isfriend\": 0,\r\n\"isfamily\": 0\r\n}"
    
    private var networkManager: NetworkManagerProtocol!
    private var photosDataController: FlickrPhotosDataController!
    
    private var flickrPhoto: FlickrPhoto!
    override func setUp() {
        super.setUp()
        
        networkManager = NetworkManager.init(flickrApiKey: "3e7cc266ae2b0e0d78e279ce8e361736")
        photosDataController = FlickrPhotosDataController.init(networkService: networkManager)
        
        do {
            flickrPhoto = try JSONDecoder.init().decode(FlickrPhoto.self, from: Data.init(flickPhotoSampleJSON.utf8))
        } catch {
            XCTFail("Error while contructing test FlickrPhoto from sample JSON")
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
        
        networkManager = nil
        photosDataController = nil
        flickrPhoto = nil
    }

    func testImageAPI() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //given
        let flickrImageExpectation = expectation(description: "flickImage")
        
        //whent
        photosDataController.fetchImage(for: flickrPhoto) { (uiImage) in
            flickrImageExpectation.fulfill()
        }
        
        //then
        wait(for: [flickrImageExpectation], timeout: 5)
    }
    
    ///will succeed if testImageAPI succeeds, cache shuld be loaded
    // improve logic
    func testImageCache() {
        let imageCacheExpectation = expectation(description: "image cache test")
        
        photosDataController.fetchImage(for: flickrPhoto) { (uiImage) in
            imageCacheExpectation.fulfill()
        }
        
        wait(for: [imageCacheExpectation], timeout: 0.0001)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
