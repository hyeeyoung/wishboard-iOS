//
//  GetUserInfoModel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/27.
//

struct GetUserInfoModel: Decodable {
    let email: String?
    let profile_img: String?
    let nickname: String?
    let push_state: Int?
  }
