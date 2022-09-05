//
//  UIButton.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import Foundation
import UIKit

extension UIButton {
    // MARK: Button
    func defaultButton(_ title: String, _ color: UIColor) {
        var config = UIButton.Configuration.tinted()
        var attText = AttributedString.init(title)
        
        attText.font = UIFont.Suit(size: 14, family: .Bold)
        attText.foregroundColor = UIColor.black
        config.attributedTitle = attText
        config.background.backgroundColor = color
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        
        self.configuration = config
    }
    // MARK: 밑줄 Button
    func setUnderline(_ title: String, _ color: UIColor) {
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        attributedString.addAttribute(.font, value: UIFont.Suit(size: 12, family: .Regular), range: NSRange(location: 0, length: title.count))
        attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: title.count))
        setAttributedTitle(attributedString, for: .normal)
    }
}
