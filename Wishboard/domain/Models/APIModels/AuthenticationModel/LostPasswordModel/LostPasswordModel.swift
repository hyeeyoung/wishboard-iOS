//
//  LostPasswordModel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/28.
//

struct LostPasswordModel: Decodable {
    let verificationCode: String?
}

struct VerifyCodeModel: Decodable {
    let token: String?
    let pushState: Int?
}
