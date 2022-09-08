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
    let navigationView = UIView()
        
    lazy var backBtn = UIButton().then{
        $0.setImage(UIImage(named: "goBack"), for: .normal)
        $0.isUserInteractionEnabled = true
    }
    let navigationTitle = UILabel().then{
        $0.text = "로그인 하기"
        $0.textColor = .black
        $0.font = UIFont.Suit(size: 15, family: .Bold)
    }
    // 이메일 TextField
    let emailTextField = UITextField().then{
        $0.defaultTextField("이메일")
    }
    // 비밀번호 TextField
    let passwordTextField = UITextField().then{
        $0.defaultTextField("비밀번호")
    }
    // 로그인하기 버튼
    let loginButton = UIButton().then{
        $0.defaultButton("로그인하기", UIColor.DisabledColor())
    }
    // 비밀번호를 잊으셨나요?
    let lostPasswordButton = UIButton().then{
        $0.setUnderline("비밀번호를 잊으셨나요?", UIColor.systemGray)
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
        addSubview(navigationView)
        navigationView.addSubview(backBtn)
        navigationView.addSubview(navigationTitle)
        
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(lostPasswordButton)
    }
    func setUpConstraint() {
        navigationView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(44)
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
        
        self.emailTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(30)
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
