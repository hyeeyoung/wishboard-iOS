//
//  RegisterEmailView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/19.
//

import Foundation
import UIKit

class RegisterEmailView: UIView {
    // MARK: - View
    let navigationView = UIView()
    let navigationTitle = UILabel().then{
        $0.text = "가입하기"
        $0.font = UIFont.Suit(size: 15, family: .Bold)
    }
    let backBtn = UIButton().then{
        $0.setImage(UIImage(named: "goBack"), for: .normal)
    }
    let stepLabel = UILabel().then{
        $0.text = "1/2 단계"
        $0.font = UIFont.Suit(size: 14, family: .Regular)
    }
    let heartLetterImage = UIImageView().then{
        $0.image = UIImage(named: "love-letter")
    }
    let subTitleLabel = UILabel().then{
        $0.text = "이메일 인증으로 비밀번호를 찾을 수 있어요.\n실제 사용될 이메일로 입력해주세요!"
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    let emailTextField = UITextField().then{
        $0.defaultTextField("이메일")
    }
    let loginButton = UIButton().then{
        $0.defaultButton("다음", .wishboardDisabledGray, .black)
    }
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpView()
        setUpConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setUpView() {
        addSubview(navigationView)
        navigationView.addSubview(navigationTitle)
        navigationView.addSubview(backBtn)
        navigationView.addSubview(stepLabel)
        
        addSubview(heartLetterImage)
        addSubview(subTitleLabel)
        addSubview(emailTextField)
        addSubview(loginButton)
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        
        heartLetterImage.snp.makeConstraints { make in
            make.height.width.equalTo(72)
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(24)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(heartLetterImage.snp.bottom).offset(10)
        }
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(42)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(32)
        }
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(56)
        }
    }
    func setUpNavigationConstraint() {
        navigationView.snp.makeConstraints{ make in
            if CheckNotch().hasNotch() {make.top.equalToSuperview().offset(50)}
            else {make.top.equalToSuperview().offset(20)}
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        backBtn.snp.makeConstraints{ make in
            make.width.height.equalTo(24)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        navigationTitle.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        stepLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
