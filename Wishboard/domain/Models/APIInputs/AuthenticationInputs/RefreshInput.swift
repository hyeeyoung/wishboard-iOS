//
//  RefreshInput.swift
//  Wishboard
//
//  Created by gomin on 2023/03/03.
//

import Foundation

struct RefreshInput: Encodable {
    let accessToken: String
    let refreshToken: String
}
