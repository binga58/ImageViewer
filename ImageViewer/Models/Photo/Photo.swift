//
//  Photo.swift
//  ImageViewer
//
//  Created by Abhishek Sharma on 11/08/18.
//  Copyright © 2018 Abhishek Sharma. All rights reserved.
//

import Foundation

struct Photo: CustomStringConvertible {
//    ["isfriend": 0, "farm": 1, "id": 43943370031, "server": 858, "secret": 10b0edf7d8, "owner": 155972353@N08, "title": IMG_2480, "ispublic": 1, "isfamily": 0]
//https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg

    let farm: Int
    let id: String
    let server: String
    let secret: String
    var owner: String?
    var title: String?
    let thumbImageURL: String
    let originalImageURL: String
    
    init(id: String, farm: Int, server: String, secret: String) {
        self.id = id
        self.farm = farm
        self.server = server
        self.secret = secret
        self.thumbImageURL = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
        self.originalImageURL = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
    }
    
    public init?(with dict:JSONDictionary) {
        guard let farm = dict[APIKey.farm] as? Int, let id = dict[APIKey.id] as? String, let server = dict[APIKey.server] as? String, let secret = dict[APIKey.secret] as? String else {
            return nil
        }
        
        self.init(id: id, farm: farm, server: server, secret: secret)
        self.title = dict[APIKey.title] as? String
        self.owner = dict[APIKey.owner] as? String
    }
    
    var description: String{
        return self.thumbImageURL
    }
    
}
