//
//  NotiData.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

struct NotificationModel: Decodable {
    let item_id: Int?
    let item_img: String?
    let item_name: String?
    let item_url: String?
    let item_notification_type: String?
    let item_notification_date: String?
    let read_state: Int?
}
