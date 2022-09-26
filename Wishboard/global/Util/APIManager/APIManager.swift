//
//  GetHeader.swift
//  Wishboard
//
//  Created by gomin on 2022/09/27.
//
import Foundation
import Alamofire
import Kingfisher

class APIManager {
    func getHeader() -> HTTPHeaders {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        return headers
    }
}
