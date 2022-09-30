//
//  FolderModel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/28.
//

struct FolderModel: Decodable {
    let folder_id: Int?
    let folder_name: String?
    let folder_thumbnail: String?
    let item_count: Int?
}
