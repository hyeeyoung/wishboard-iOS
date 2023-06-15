//
//  LostPasswordInput.swift
//  Wishboard
//
//  Created by gomin on 2022/09/28.
//

struct LostPasswordInput: Encodable {
    let verify: Bool
    let email: String
    let fcmToken: String
}
