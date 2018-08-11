//
//  ImageManager.swift
//  ImageViewer
//
//  Created by Abhishek Sharma on 12/08/18.
//  Copyright © 2018 Abhishek Sharma. All rights reserved.
//

import Foundation
import UIKit

let flickrKey = "03b3265e6929a47139957d046cd453d5"
let flickrSecret = "d86c611732d81d2a"
let flickrBaseURL = "https://api.flickr.com/services/rest/"
let flickrPerPageImages = "20"

class ImageManager {
    
    static let shared = ImageManager()
    
    var imageCache =  NSCache<NSString, UIImage>()
    
    func fetchImages(text: String) {
        
        let parameters = [APIKey.method: APIKey.flickrPhotoSearch, APIKey.apiKey:flickrKey, APIKey.text: text, APIKey.perPage : flickrPerPageImages, APIKey.format: APIKey.json, APIKey.nojsoncallback : "1"]
        
        let stringParameters = NetworkClass.stringFromQueryParameters(parameters)
        let urlString = "\(flickrBaseURL)?\(stringParameters)"
        
        NetworkClass.sendRequest(url: urlString, incluedBaseURl: false, requestType: .get, parameters: nil, completion: { (status, response, error, code) in
            
            if status, let result = response as? JSONDictionary,
                let photos = result[APIKey.photos] as? JSONDictionary,
                let photoArray = photos[APIKey.photo] as? Array<JSONDictionary>,
                let totalPages = photos[APIKey.pages] as? Int,
                let currentPage = photos[APIKey.page] as? Int{
                
                print(photoArray)
                
            }
            
        })
        
        
        
    }
    
    
}

