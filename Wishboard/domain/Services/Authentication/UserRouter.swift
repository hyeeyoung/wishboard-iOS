//
//  UserRouter.swift
//  Wishboard
//
//  Created by gomin on 2023/03/20.
//

import Foundation
import Moya
import UIKit

struct MoyaProfileInput {
    let photo: UIImage?
    let nickname: String?
}

enum UserRouter: BaseRouter{
    case signIn(param: LoginInput)
    case modifyPassword(pw: String)
    case modifyProfile(param: MoyaProfileInput)
}

extension UserRouter{
    
    var path: String {
        switch self {
        case .signIn:
            return HTTPMethodURL.POST.signIn
        case .modifyPassword:
            return HTTPMethodURL.PUT.modifyPassword
        case .modifyProfile:
            return HTTPMethodURL.PUT.modifyProfile
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        case .modifyPassword:
            return .put
        case .modifyProfile:
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
        case .modifyProfile(let param):
            let formData = makeMultipartFormData(param: param)
            return .uploadMultipart(formData)
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
                "Authorization": "Bearer " + token]
            return header
        case .modifyProfile:
            let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
            return ["Content-Type": "multipart/form-data",
                    "Authorization": "Bearer " + token]
        }
        
    }
    
    func makeMultipartFormData(param: MoyaProfileInput) -> [Moya.MultipartFormData] {
        var nicknameData: MultipartFormData?
        var imageMultipartFormData: MultipartFormData?
        var formData: [Moya.MultipartFormData] = []
        
        if let nickname = param.nickname {
            nicknameData = MultipartFormData(provider: .data(nickname.data(using: String.Encoding.utf8) ?? Data()), name: "nickname")
            if let nicknameData = nicknameData {
                formData.append(nicknameData)
            }
        }

        if let image = param.photo {
            let imageData = image.resizeImageIfNeeded().jpegData(compressionQuality: 1.0) ?? Data()
            imageMultipartFormData = MultipartFormData(provider: .data(imageData), name: "profile_img", fileName: "profileImg.jpeg", mimeType: "image/jpeg")
            if let imageMultipartFormData = imageMultipartFormData {
                formData.append(imageMultipartFormData)
            }
        }
        
        return formData
    }
}
