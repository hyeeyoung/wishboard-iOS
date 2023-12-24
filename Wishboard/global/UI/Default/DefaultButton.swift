//
//  DefaultButton.swift
//  Wishboard
//
//  Created by gomin on 2023/03/19.
//

import Foundation
import UIKit
import Lottie


class LoadingButton: UIButton {

    private var animationView: LottieAnimationView?
    
    var isActivate: Bool = true {
        didSet{
            isActivate ? activateButton() : inactivateButton()
        }
    }
    
    /// 지렁이 로띠뷰
    init(_ title: String) {
        super.init(frame: CGRect.zero)
        
        setupHorizontalBlack()
        
        setTitle(title, for: .normal)
        setTitleColor(UIColor.gray_300, for: .normal)
        titleLabel?.setTypoStyleWithSingleLine(typoStyle: .SuitH3)
        backgroundColor = UIColor.gray_100
        
        clipsToBounds = true
        layer.cornerRadius = 22
    }
    
    /// 초록 돌돌이 로띠뷰
    init(_ title: String, _ vc: UIViewController) {
        super.init(frame: CGRect.zero)
        
        setupSpinGreen(vc)
        
        setTitle(title, for: .normal)
        setTitleColor(UIColor.gray_300, for: .normal)
        titleLabel?.setTypoStyleWithSingleLine(typoStyle: .SuitH3)
        backgroundColor = UIColor.gray_100
        
        clipsToBounds = true
        layer.cornerRadius = 22
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    private func setupHorizontalBlack() {
        // Lottie 애니메이션 초기화
        animationView = LottieAnimationView(name: "loading_horizontal_black") // Lottie 애니메이션 파일명으로 변경
        animationView?.loopMode = .loop
        animationView?.isUserInteractionEnabled = false

        // 로딩 상태를 나타낼 뷰 추가
        addSubview(animationView!)
        animationView?.center = center
        animationView?.stop()
        
        animationView?.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalToSuperview()
            make.centerY.centerX.equalToSuperview()
        }

        animationView?.isHidden = true
    }
    private func setupSpinGreen(_ vc: UIViewController) {
        // Lottie 애니메이션 초기화
        animationView = LottieAnimationView(name: "loading_spin") // Lottie 애니메이션 파일명으로 변경
        animationView?.loopMode = .loop
        animationView?.isUserInteractionEnabled = false

        // 로딩 상태를 나타낼 뷰 추가
        vc.view.addSubview(animationView!)
        animationView?.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerY.centerX.equalToSuperview()
        }
        
        animationView?.isHidden = true
    }

    // MARK: Methods
    
    func startLoadingAnimation() {
        // 로딩 애니메이션 시작
        isEnabled = false
        titleLabel?.isHidden = true
        titleLabel?.alpha = 0
        
        animationView?.isHidden = false
        animationView?.play()
    }

    func stopLoadingAnimation() {
        // 로딩 애니메이션 멈춤
        isEnabled = true
        titleLabel?.isHidden = false
        titleLabel?.alpha = 1
        
        animationView?.isHidden = true
        animationView?.stop()
    }

    func activateButton() {
        self.backgroundColor = UIColor.green_500
        self.setTitleColor(UIColor.gray_700, for: .normal)
        isEnabled = true
        
        titleLabel?.isHidden = false
        titleLabel?.alpha = 1
        
        animationView?.isHidden = true
        animationView?.stop()
    }
    
    func inactivateButton() {
        self.backgroundColor = UIColor.gray_100
        self.setTitleColor(UIColor.gray_300, for: .normal)
        isEnabled = false
        
        titleLabel?.isHidden = false
        titleLabel?.alpha = 1
        
        animationView?.isHidden = true
        animationView?.stop()
    }
    
    func needLoginButton() {
        setTitle(Button.doLogin, for: .normal)
        backgroundColor = UIColor.gray_100
        setTitleColor(UIColor.gray_300, for: .normal)
        isEnabled = false
    }
}
