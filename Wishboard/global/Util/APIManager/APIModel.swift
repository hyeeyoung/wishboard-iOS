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
    let token: String?
}
