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
    let emailTextField = DefaultTextField(Placeholder.email)
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
        $0.setUnderline(Button.lostPassword, UIColor.systemGray)
    }
    // 키보드 위 Accessory
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 100.0))
    }()
    // 로그인하기 버튼
    let loginButtonKeyboard = DefaultButton(titleStr: Button.login).then{
        $0.isActivate = false
    }
    // 비밀번호를 잊으셨나요?
    let lostPasswordButtonKeyboard = UIButton().then{
        $0.setUnderline(Button.lostPassword, UIColor.systemGray)
    }
    
    // MARK: - Functions
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpTextField()
        setUpView()
        setUpConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpTextField() {
        emailTextField.inputAccessoryView = accessoryView
        passwordTextField.inputAccessoryView = accessoryView
    }
    func setUpView() {
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(lostPasswordButton)
        
        accessoryView.addSubview(loginButtonKeyboard)
        accessoryView.addSubview(lostPasswordButtonKeyboard)
    }
    func setUpConstraint() {
        self.emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(32)
        }
        self.emailTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.equalTo(emailLabel)
            make.centerX.equalToSuperview()
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
        }
        self.passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(32)
            make.leading.equalTo(emailTextField)
        }
        self.passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.equalTo(emailLabel)
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
        }
        self.lostPasswordButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-34)
        }
        self.loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(lostPasswordButton.snp.top).offset(-16)
        }
        // keyboard button
        self.lostPasswordButtonKeyboard.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        self.loginButtonKeyboard.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(lostPasswordButtonKeyboard.snp.top).offset(-16)
        }
    }
}
