//
//  UIButton.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import Foundation
import UIKit
import Lottie

extension UIButton {
    func clearButton(_ button: UIButton) {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        config.baseForegroundColor = .clear
        
        self.configuration = config
    }
    // MARK: 밑줄 Button
    func setUnderline(_ title: String, _ color: UIColor) {
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        attributedString.addAttribute(.font, value: UIFont.Suit(size: 12, family: .Bold), range: NSRange(location: 0, length: title.count))
        attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: title.count))
        setAttributedTitle(attributedString, for: .normal)
    }
    func setUnderline(_ title: String, _ color: UIColor, _ font: UIFont) {
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: title.count))
        attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: title.count))
        setAttributedTitle(attributedString, for: .normal)
    }
    // MARK: Cart Button
    func cartButton(_ color: UIColor) {
        var config = UIButton.Configuration.tinted()
        var attText = AttributedString.init("Cart")
        
        attText.font = UIFont.Suit(size: 11.46, family: .Regular)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        attText.foregroundColor = UIColor.black
        config.attributedTitle = attText
        config.background.backgroundColor = color
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        
        self.configuration = config
    }
    // MARK: - Email resend button
    func resendButton(_ color: UIColor) {
        var config = UIButton.Configuration.tinted()
        var attText = AttributedString.init("재전송")
        
        attText.font = UIFont.Suit(size: 14, family: .Bold)
        attText.foregroundColor = color
        
        config.attributedTitle = attText
        config.background.backgroundColor = .wishboardTextfieldGray
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        self.configuration = config
    }
    // MARK: - Share Viewcontroller's setNotification button
    func setNotificationButton(_ date: String, _ isSet: Bool) {
        var config = UIButton.Configuration.plain()
        var attText: AttributedString!
        
        if isSet {
            attText = AttributedString.init(" " + date)
        }
        else {
            attText = AttributedString.init(" 상품 알림 설정하기")
        }
        attText.font = UIFont.Suit(size: 12, family: .Regular)
        attText.foregroundColor = UIColor.black
        config.attributedTitle = attText
        config.image = Image.noti
        
        self.configuration = config
    }
    // MARK: 폴더 지정하기 버튼
    func setFolderButton(_ title: String) {
        var config = UIButton.Configuration.plain()
        var attText = AttributedString.init(title)
        
        attText.font = .systemFont(ofSize: 12)
        attText.foregroundColor = UIColor.gray
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.attributedTitle = attText
        
        self.configuration = config
    }
}
