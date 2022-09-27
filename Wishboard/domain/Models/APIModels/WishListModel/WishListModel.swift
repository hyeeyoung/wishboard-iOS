//
//  WishListModel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import Foundation

struct WishListModel: Decodable {
    var folder_id: Int?
    var folder_name: String?
    var item_id: Int?
    var item_img_url: String?
    var item_name: String?
    var item_price: String?
    var item_url: String?
    var item_memo: String?
    var create_at: String?
    var item_notification_type: String?
    var item_notification_date: String?
    var cart_state: Int?
}
struct CartListModel {
    let itemImage: String?
    let itemName: String?
    let itemPrice: Int?
    let itemCount: Int?
}
