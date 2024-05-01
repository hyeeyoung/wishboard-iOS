//
//  BaseRouter.swift
//  Wishboard
//
//  Created by gomin on 2023/03/19.
//

import Foundation
import Moya

protocol BaseRouter: Moya.TargetType {
}

extension BaseRouter {

    var baseURL: URL {
        let url = Storage().BaseURL
        return URL(string: url)!
    }

    var headers: [String: String]? {
        let token = UserManager.accessToken ?? ""
        let header = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token,
            "User-Agent": "wishboard-ios/dev"
        ]
        return header
    }

    var sampleData: Data {
        return Data()
    }

}
