//
//  Photo.swift
//  ImageViewer
//
//  Created by Abhishek Sharma on 11/08/18.
//  Copyright © 2018 Abhishek Sharma. All rights reserved.
//

import Foundation

struct Photo: Codable {
//    ["isfriend": 0, "farm": 1, "id": 43943370031, "server": 858, "secret": 10b0edf7d8, "owner": 155972353@N08, "title": IMG_2480, "ispublic": 1, "isfamily": 0]
//    "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
    var farm: String?
    var id: String?
    var server: String?
    var secret: String?
    var owner: String?
    var title: String?
    
    
    
    
}
