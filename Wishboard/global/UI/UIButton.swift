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
    // MARK: Button
    func defaultButton(_ title: String, _ backgroundColor: UIColor, _ titleColor: UIColor) {
        var config = UIButton.Configuration.tinted()
        var attText = AttributedString.init(title)
        
        attText.font = UIFont.Suit(size: 14, family: .Bold)
        attText.foregroundColor = titleColor
        config.attributedTitle = attText
        config.background.backgroundColor = backgroundColor
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        
        self.configuration = config
        self.setTitle("", for: .selected)
    }
    func setHorizontalLottieView(_ button: UIButton) -> AnimationView {
        let lottieView = SetLottie().horizontalBlackView
        button.addSubview(lottieView)
        lottieView.isHidden = true
        
        lottieView.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalToSuperview()
            make.centerY.centerX.equalToSuperview()
        }
        return lottieView
    }
    func setSpinLottieView(_ button: UIButton) -> AnimationView {
        let lottieView = SetLottie().spinView
        button.addSubview(lottieView)
        lottieView.isHidden = true
        
        lottieView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.centerX.equalToSuperview()
        }
        clearButton(button)
        return lottieView
    }
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
        attributedString.addAttribute(.font, value: UIFont.Suit(size: 12, family: .Regular), range: NSRange(location: 0, length: title.count))
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
        config.image = UIImage(named: "ic_noti")
        
        self.configuration = config
    }
    // MARK: 폴더 지정하기 버튼
    func setFolderButton(_ title: String) {
        var config = UIButton.Configuration.plain()
        var attText = AttributedString.init(title)
        
        attText.font = .systemFont(ofSize: 13)
        attText.foregroundColor = UIColor.wishboardGray
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.attributedTitle = attText
        
        self.configuration = config
    }
}
