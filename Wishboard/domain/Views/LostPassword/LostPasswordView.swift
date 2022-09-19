//
//  LostPasswordView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/20.
//

import Foundation
import UIKit

class LostPasswordView: UIView {
    // MARK: - View
    let navigationView = UIView()
    let navigationTitle = UILabel().then{
        $0.text = "이메일로 로그인하기"
        $0.font = UIFont.Suit(size: 15, family: .Bold)
    }
    let backBtn = UIButton().then{
        $0.setImage(UIImage(named: "goBack"), for: .normal)
    }
    let heartLetterImage = UIImageView().then{
        $0.image = UIImage(named: "love-letter")
    }
    let subTitleLabel = UILabel().then{
        $0.text = "가입하신 이메일을 입력해주세요!\n로그인을 위해 인증코드가 포함된 이메일을 보내드려요."
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    var emailTextField = UITextField().then{
        $0.defaultTextField("이메일")
        $0.becomeFirstResponder()
    }
    let errorMessage = UILabel().then{
        $0.text = "이메일 주소를 정확하게 입력해주세요."
        $0.textColor = .wishboardRed
        $0.font = UIFont.Suit(size: 12, family: .Regular)
    }
    let getEmailButton = UIButton().then{
        $0.defaultButton("인증메일 받기", .wishboardDisabledGray, .black)
    }
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 72.0))
    }()
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emailTextField.inputAccessoryView = accessoryView // <-
        errorMessage.isHidden = true

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
        
        addSubview(heartLetterImage)
        addSubview(subTitleLabel)
        addSubview(emailTextField)
        addSubview(errorMessage)
        
        accessoryView.addSubview(getEmailButton)
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
        errorMessage.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(6)
        }
        getEmailButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(16)
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
    }
}
