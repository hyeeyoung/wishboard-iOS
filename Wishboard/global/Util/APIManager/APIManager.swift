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
    let token = UserManager.accessToken ?? ""
    
    func getHeader() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Content-Type": "application/json"
        ]
        return headers
    }
    func getMultipartHeader() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization": "Bearer " + token
        ]
        return headers
    }
    
}
