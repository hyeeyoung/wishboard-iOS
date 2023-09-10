//
//  LoginView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import Foundation
import UIKit
import Then
import SnapKit

class LoginView: UIView {
    // MARK: - Views
    // 이메일 Label
    let emailLabel = DefaultLabel().then{
        $0.text = Title.email
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitB3)
    }
    // 이메일 TextField
    let emailTextField = DefaultTextField(Placeholder.email).then {
        $0.keyboardType = .emailAddress
        $0.becomeFirstResponder()
    }
    // 비밀번호 Label
    let passwordLabel = DefaultLabel().then{
        $0.text = Title.password
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitB3)
    }
    // 비밀번호 TextField
    let passwordTextField = DefaultTextField(Placeholder.password).then{
        $0.isSecureTextEntry = true
    }
    // 로그인하기 버튼
    let loginButton = DefaultButton(titleStr: Button.login).then{
        $0.isActivate = false
    }
    // 비밀번호를 잊으셨나요?
    let lostPasswordButton = UIButton().then{
        $0.setUnderline(Button.lostPassword, .gray_300, TypoStyle.SuitB3.font)
    }
    
    // MARK: - Functions
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpView()
        setUpConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(lostPasswordButton)
    }
    func setUpConstraint() {
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(32)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.equalTo(emailLabel)
            make.centerX.equalToSuperview()
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(32)
            make.leading.equalTo(emailTextField)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.equalTo(emailLabel)
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
        }
        lostPasswordButton.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-34)
        }
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(lostPasswordButton.snp.top).offset(-16)
        }
    }
}
