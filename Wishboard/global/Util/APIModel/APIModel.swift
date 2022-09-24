//
//  APIModel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/25.
//

struct APIModel<T: Decodable>: Decodable {
    let success: Bool?
    let message: String?
    let token: String?
    let data: T?
    
}
struct DataModel: Decodable {
    
}
