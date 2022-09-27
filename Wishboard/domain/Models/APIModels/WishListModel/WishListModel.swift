//
//  WishListModel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import Foundation

struct WishListModel: Decodable {
    let folder_id: Int?
    let folder_name: String?
    let item_id: Int?
    let item_img_url: String?
    let item_name: String?
    let item_price: String?
    let item_url: String?
    let item_memo: String?
    let create_at: String?
    let item_notification_type: String?
    let item_notification_date: String?
    let cart_state: Int?
}
struct CartListModel {
    let itemImage: String?
    let itemName: String?
    let itemPrice: Int?
    let itemCount: Int?
}
