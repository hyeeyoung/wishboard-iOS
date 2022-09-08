//
//  UIFont.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import Foundation
import UIKit

extension UIFont{
    
    enum Family: String {
        case Bold, Regular, Light
    }
    
    static func Suit(size: CGFloat = 14, family: Family = .Regular) -> UIFont! {
        guard let font: UIFont = UIFont(name: "SUIT-\(family)", size: size) else {
            return nil
        }
        return font
    }
    static func monteserrat(size: CGFloat = 14) -> UIFont! {
        guard let font: UIFont = UIFont(name: "Montserrat-VariableFont_wght", size: size) else {
            return nil
        }
        return font
    }
}
