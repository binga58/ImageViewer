//
//  StringExtension.swift
//  ImageViewer
//
//  Created by Abhishek Sharma on 12/08/18.
//  Copyright © 2018 Abhishek Sharma. All rights reserved.
//

import Foundation

extension String{
    
    public func urlEncoded() -> String {
        let string = self
        
        var characterSet = NSMutableCharacterSet.urlQueryAllowed
        
        let delimitersToEncode = ":#[]@!$?&'()*+= "
        characterSet.remove(charactersIn: delimitersToEncode)
        
        return string.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet) ?? string
    }
    
    
}
