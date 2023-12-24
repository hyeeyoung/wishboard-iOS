//
//  Observer.swift
//  Wishboard
//
//  Created by gomin on 2023/09/02.
//

import Foundation

protocol Observer: AnyObject {
    func update(_ newValue: Any)
}
