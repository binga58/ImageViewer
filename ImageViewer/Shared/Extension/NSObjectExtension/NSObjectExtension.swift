//
//  NSObjectExtension.swift
//  ImageViewer
//
//  Created by Abhishek Sharma on 11/08/18.
//  Copyright © 2018 Abhishek Sharma. All rights reserved.
//

import Foundation

extension NSObject
{
    static func className() -> String{
        return String(describing : self)
    }
}
