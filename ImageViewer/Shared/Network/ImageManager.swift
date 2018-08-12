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
let flickrPerPageImages = "100"
let imageCache = "ImageCache"
let mb = 1024 * 1024

typealias ImageFetchCompletion = (_ images: Array<Photo>?, _ totalPage: Int, _ currentPage: Int, _ searchText: String) -> ()
typealias ImageDownloadCompletion = (_ imageURL: String, _ image: UIImage?) -> ()


class ImageManager: NSObject, URLSessionTaskDelegate {
    
    static let shared = ImageManager()
    let operationQueue: OperationQueue = OperationQueue()
    var urlCache = URLCache(memoryCapacity: 20 * mb, diskCapacity: 100 * mb, diskPath: imageCache)
    var requestQueue: Dictionary<URL, URLSessionDataTask> = [:]
    var session: URLSession!
    
    override init() {
        super.init()
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = urlCache
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: operationQueue)
        
    }
    
}

extension ImageManager {
    
    func downloadImage(imageURL: String, completion: ImageDownloadCompletion?) {
        if let url = URL(string: imageURL) {
            let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            //Check for image in cache
            if let response = urlCache.cachedResponse(for: urlRequest) {
                let image = UIImage(data: response.data)
                completion?(imageURL, image)
            } else {
                
                //Check if image request is already present
                if let task = requestQueue[url] {
                    task.priority = URLSessionTask.highPriority
                } else {
                    //Else download
                    self.download(imageURL: imageURL, completion: completion)
                }
            }
            
        } else {
            completion?(imageURL, nil)
        }
        
    }
    
    private func download(imageURL: String, completion: ImageDownloadCompletion?) {
        
        if let url = URL(string: imageURL) {
            //Create request
            let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            
            let task = self.session.dataTask(with: urlRequest) {[weak self] (data, response, error) in
                
                if let data = data, let image = UIImage(data: data) {
                    completion?(imageURL, image)
                } else {
                    completion?(imageURL, nil)
                }
                self?.removeRequestFromQueue(url: url)
            }
            
            task.priority = URLSessionTask.highPriority
            requestQueue[url] = task
            task.resume()
            
        } else {
            completion?(imageURL, nil)
        }
        
    }
    
    private func removeRequestFromQueue(url: URL) {
        requestQueue.removeValue(forKey: url)
    }
    
    func setLowPriority(url: URL) {
        if let task = requestQueue[url] {
            task.priority = URLSessionTask.lowPriority
        }
    }
    
}

//MARK:- Images List Fetch
extension ImageManager {
    
    func fetchImages(text: String, currentPage: Int, completion: ImageFetchCompletion?) {
        
        let parameters = [APIKey.method: APIKey.flickrPhotoSearch, APIKey.apiKey:flickrKey, APIKey.text: text, APIKey.perPage : flickrPerPageImages, APIKey.format: APIKey.json, APIKey.nojsoncallback : "1", APIKey.page: String(currentPage)]
        
        let stringParameters = NetworkClass.stringFromQueryParameters(parameters)
        let urlString = "\(flickrBaseURL)?\(stringParameters)"
        
        NetworkClass.sendRequest(url: urlString, incluedBaseURl: false, requestType: .get, parameters: nil, completion: { (status, response, error, code) in
            
            if status, let result = response as? JSONDictionary,
                let photosDict = result[APIKey.photos] as? JSONDictionary,
                let photoArray = photosDict[APIKey.photo] as? Array<JSONDictionary>,
                let totalPage = photosDict[APIKey.pages] as? Int,
                let currentPage = photosDict[APIKey.page] as? Int{
                
                var photos: Array<Photo> = []
                for photoDict in photoArray {
                    if let photo = Photo(with: photoDict) {
                        photos.append(photo)
                    }
                }
                completion?(photos,totalPage, currentPage, text)
            } else {
                completion?(nil, 0, 0, text)
            }
            
            
        })
        
    }
    
}

