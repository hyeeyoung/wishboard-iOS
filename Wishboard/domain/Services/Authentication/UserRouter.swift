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
    case modifyPassword(pw: String)
    
}

extension UserRouter{
    
    var path: String {
        switch self {
        case .signIn:
            return HTTPMethodURL.POST.signIn
        case .modifyPassword:
            return HTTPMethodURL.PUT.modifyPassword
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        case .modifyPassword:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let param):
            return .requestJSONEncodable(param)
        case .modifyPassword(let pw):
            let param = ModifyPasswordInput(newPassword: pw)
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .signIn:
            return ["Content-Type": "application/json"]
        case .modifyPassword:
            let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
            let header = [
                "Content-Type": "application/json",
                "Authorization": "Bearer Token " + token]
            return header
        }
        
    }
}
