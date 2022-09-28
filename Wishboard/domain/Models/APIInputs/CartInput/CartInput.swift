//
//  CartInput.swift
//  Wishboard
//
//  Created by gomin on 2022/09/29.
//

struct AddCartInput: Encodable {
    let item_id: Int?
}

struct CartModifyCountInput: Encodable {
    let item_count: Int?
}
