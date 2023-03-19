//
//  APIModel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/25.
//

enum NetworkResult<T>{
    typealias Code = String
    typealias Message = String
    case success(T)
    case invalidSuccess(Code, Message)
    case failure(Error?)
}

struct StatusResponseModel: Decodable{
    let success: Bool
    let message: String
}

struct APIModel<T: Decodable>: Decodable {
    let success: Bool
    let message: String?
    let data: T?
}
struct ResultModel: Decodable {
    let data: String?
}
struct TokenResultModel: Decodable {
    let token: TokenModel
    let tempNickname: String?
}
struct TokenModel: Decodable {
    let accessToken: String
    let refreshToken: String
}
