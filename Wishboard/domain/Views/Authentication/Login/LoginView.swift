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
    // 이메일 TextField
    let emailTextField = UITextField().then{
        $0.defaultTextField(Placeholder.email)
        $0.textColor = .editTextFontColor
    }
    // 비밀번호 TextField
    let passwordTextField = UITextField().then{
        $0.defaultTextField(Placeholder.password)
        $0.isSecureTextEntry = true
        $0.textColor = .editTextFontColor
    }
    // 로그인하기 버튼
    let loginButton = UIButton().then{
        $0.defaultButton(Button.login, .wishboardDisabledGray, .dialogMessageColor)
        $0.isEnabled = false
    }
    // 비밀번호를 잊으셨나요?
    let lostPasswordButton = UIButton().then{
        $0.setUnderline(Button.lostPassword, UIColor.systemGray)
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
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(lostPasswordButton)
    }
    func setUpConstraint() {
        self.emailTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        self.passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
        }
        self.loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
        }
        self.lostPasswordButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(16)
        }
    }
}
