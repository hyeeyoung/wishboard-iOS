//
//  HTTPMethodURL.swift
//  Wishboard
//
//  Created by gomin on 2023/03/19.
//

import Foundation

enum HTTPMethodURL {
    
    static let authURL = "/auth"
    static let itemURL = "/item"
    static let userURL = "/user"
    
    struct GET {
        static let user = HTTPMethodURL.authURL
    }
    
    struct POST {
        static let signIn = HTTPMethodURL.authURL + "/signin"
        static let uploadItem = HTTPMethodURL.itemURL
    }
    
    struct PUT {
        static let modifyITem = HTTPMethodURL.itemURL
        static let modifyPassword = HTTPMethodURL.userURL + "/re-passwd"
    }
    
    struct DELETE {
        
    }
    
    
}
