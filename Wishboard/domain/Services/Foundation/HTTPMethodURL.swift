//
//  HTTPMethodURL.swift
//  Wishboard
//
//  Created by gomin on 2023/03/19.
//

import Foundation

enum HTTPMethodURL {
    
    static let userURL = "/auth"
    
    struct GET {
        static let user = HTTPMethodURL.userURL
    }
    
    struct POST {
        static let signIn = HTTPMethodURL.userURL + "/signin"
    }
    
    struct PUT {
        
    }
    
    struct DELETE {
        
    }
    
    
}
