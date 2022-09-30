//
//  CartModel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/28.
//

struct CartListModel: Decodable {
    let wishItem: CartItemModel?
    let cartItemInfo: CartItemCountModel?
}

struct CartItemModel: Decodable {
    let folder_id: Int?
    let folder_name: String?
    let item_id: Int?
    let item_img: String?
    let item_name: String?
    let item_price: String?
    let item_url: String?
    let item_memo: String?
    let create_at: String?
    let item_notification_type: String?
    let item_notification_date: String?
    let cart_state: Int?
}

struct CartItemCountModel: Decodable {
    let item_count: Int?
}
