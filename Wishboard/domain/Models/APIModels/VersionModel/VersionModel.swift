//
//  VersionModel.swift
//  Wishboard
//
//  Created by gomin on 9/25/24.
//

import Foundation

struct VersionModel: Decodable {
    let platform: String?
    let min_version: String?
    let recommended_version: String?
}
