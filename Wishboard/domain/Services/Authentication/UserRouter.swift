//
//  UserRouter.swift
//  Wishboard
//
//  Created by gomin on 2023/03/20.
//

import Foundation
import Moya
import UIKit

enum UserRouter: BaseRouter{
    case signIn(param: LoginInput)
    
}

extension UserRouter{
    
    var path: String {
        switch self {
        case .signIn:
            return HTTPMethodURL.POST.signIn
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
