//
//  DefaultButton.swift
//  Wishboard
//
//  Created by gomin on 2023/03/19.
//

import Foundation
import UIKit
import Lottie

class DefaultButton: UIButton {
    var isActivate = false{
        didSet{
            isActivate ? activateButton() : inactivateButton()
        }
    }
    var lottieView: LottieAnimationView!
    var titleStr: String?
    var titleColor: UIColor?
    
    // MARK: - Life Cycle
    
    // 디폴트 초록 배경 버튼
    init(titleStr: String) {
        super.init(frame: CGRect.zero)
        
        self.titleStr = titleStr
        
        self.setTitle(titleStr, for: .normal)
        self.setTitleColor(UIColor.dialogMessageColor, for: .normal)
        self.titleLabel?.font = UIFont.Suit(size: 14, family: .Bold)
        self.backgroundColor = UIColor.wishboardDisabledGray
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 22
        
        self.setTitle("", for: .selected)
    }
    
    // 제목, 배경색, 글씨색 설정
    init(titleStr: String, titleColor: UIColor, backgroundColor: UIColor) {
        super.init(frame: CGRect.zero)
        
        self.titleStr = titleStr
        
        self.setTitle(titleStr, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.Suit(size: 14, family: .Bold)
        self.backgroundColor = backgroundColor
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 22
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    func activateButton() {
        self.backgroundColor = UIColor.wishboardGreen
        self.titleLabel?.textColor = UIColor.black
        self.isEnabled = true
    }
    func inactivateButton() {
        self.backgroundColor = UIColor.wishboardDisabledGray
        self.titleLabel?.textColor = UIColor.dialogMessageColor
        self.isEnabled = false
    }
    // MARK: Lottie View
    func setLottieView() -> LottieAnimationView {
        self.lottieView = SetLottie().horizontalBlackView
        self.addSubview(lottieView)
        
        lottieView.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalToSuperview()
            make.centerY.centerX.equalToSuperview()
        }
        activateLottieView()
        
        return lottieView
    }
    func activateLottieView() {
        self.lottieView.isHidden = false
        self.titleLabel?.isHidden = true
        self.isSelected = true
    }
    func inActivateLottieView() {
        self.lottieView.isHidden = true
        self.titleLabel?.isHidden = false
    }
}
