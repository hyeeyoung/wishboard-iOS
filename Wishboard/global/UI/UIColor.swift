//
//  UIColor.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import Foundation
import UIKit

extension UIColor{
    
    static func SignatureColor() -> UIColor! {
        guard let color: UIColor = UIColor(named: "WishBoardColor") else{
            return nil
        }
        return color
    }
}
