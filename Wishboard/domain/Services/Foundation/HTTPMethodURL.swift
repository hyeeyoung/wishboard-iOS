//
//  HTTPMethodURL.swift
//  Wishboard
//
//  Created by gomin on 2023/03/19.
//

import Foundation

enum HTTPMethodURL {
    
    static let userURL = "/auth"
    static let itemURL = "/item"
    
    struct GET {
        static let user = HTTPMethodURL.userURL
    }
    
    struct POST {
        static let signIn = HTTPMethodURL.userURL + "/signin"
        static let uploadItem = HTTPMethodURL.itemURL
    }
    
    struct PUT {
        static let modifyITem = HTTPMethodURL.itemURL
    }
    
    struct DELETE {
        
    }
    
    
}
