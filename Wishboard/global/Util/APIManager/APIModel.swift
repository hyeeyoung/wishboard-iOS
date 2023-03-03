//
//  APIModel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/25.
//

struct APIModel<T: Decodable>: Decodable {
    let success: Bool?
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
