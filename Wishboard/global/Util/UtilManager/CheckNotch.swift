//
//  CheckNotch.swift
//  Wishboard
//
//  Created by gomin on 2022/09/14.
//

import Foundation
import UIKit

class CheckNotch {
    func hasNotch() -> Bool {
//        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return true
    }
}
extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
