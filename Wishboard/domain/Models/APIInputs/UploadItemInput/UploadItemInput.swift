//
//  UploadItemInput.swift
//  Wishboard
//
//  Created by gomin on 2022/09/29.
//

struct UploadItemInput: Encodable {
    let item_img: String?
    let item_name: String?
    let item_price: String?
    let item_url: String?
    let item_memo: String?
}
struct UploadItemInputWithFolder: Encodable {
    let item_img: String?
    let item_name: String?
    let item_price: String?
    let item_url: String?
    let item_memo: String?
    let folder_id: Int?
}
struct UploadItemInputWithAll: Encodable {
    let item_img: String?
    let item_name: String?
    let item_price: String?
    let item_url: String?
    let item_memo: String?
    let folder_id: Int?
    let item_notification_date: String?
    let item_notification_type: String?
}
