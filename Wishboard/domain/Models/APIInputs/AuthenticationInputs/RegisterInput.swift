//
//  RegisterInput.swift
//  Wishboard
//
//  Created by gomin on 2022/09/26.
//

struct RegisterInput: Encodable {
    let email: String
    let password: String
    let fcmToken: String
}
