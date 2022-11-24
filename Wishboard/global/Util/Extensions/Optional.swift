//
//  Optional.swift
//  Wishboard
//
//  Created by gomin on 2022/11/25.
//

import Foundation

extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}
