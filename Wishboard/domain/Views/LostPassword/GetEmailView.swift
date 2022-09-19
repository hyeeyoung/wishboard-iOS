//
//  GetEmailView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/20.
//

import Foundation
import UIKit

class GetEmailView: UIView {
    // MARK: - Views
    let navigationView = UIView()
        
    lazy var backBtn = UIButton().then{
        $0.setImage(UIImage(named: "goBack"), for: .normal)
        $0.isUserInteractionEnabled = true
    }
    let navigationTitle = UILabel().then{
        $0.text = "이메일로 로그인하기"
        $0.textColor = .black
        $0.font = UIFont.Suit(size: 15, family: .Bold)
    }
    // 이메일 TextField
    var emailTextField = UITextField().then{
        $0.defaultTextField("이메일")
        $0.becomeFirstResponder()
        $0.clearButtonMode = .never
    }
    lazy var resendEmailButton = UIButton().then{
        $0.resendButton(.wishboardGreen)
    }
    let errorMessage = UILabel().then{
        $0.text = "이메일 주소를 정확하게 입력해주세요."
        $0.textColor = .wishboardRed
        $0.font = UIFont.Suit(size: 12, family: .Regular)
    }
    // 인증코드 TextField
    let codeTextField = UITextField().then{
        $0.defaultTextField("인증코드")
        $0.isSecureTextEntry = true
    }
    var timerLabel = UILabel().then{
        $0.text = "5:00"
        $0.font = UIFont.Suit(size: 14, family: .Regular)
        $0.textColor = .wishboardRed
    }
    // 로그인하기 버튼
    let loginButton = UIButton().then{
        $0.defaultButton("로그인하기", .wishboardDisabledGray, .black)
    }
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 72.0))
    }()
    // MARK: - Life Cylces
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpTextFields()
        setUpView()
        setUpConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setUpTextFields() {
        emailTextField.inputAccessoryView = accessoryView // <-
        emailTextField.rightView = resendEmailButton
        emailTextField.rightViewMode = .always
        
        codeTextField.inputAccessoryView = accessoryView // <-
        errorMessage.isHidden = true
    }
    func setUpView() {
        addSubview(navigationView)
        navigationView.addSubview(backBtn)
        navigationView.addSubview(navigationTitle)
        
        addSubview(emailTextField)
//        emailTextField.addSubview(resendEmailButton)
//        bringSubviewToFront(resendEmailButton)
        
        addSubview(errorMessage)
        addSubview(codeTextField)
        codeTextField.addSubview(timerLabel)
        
        accessoryView.addSubview(loginButton)
    }
    func setUpConstraint() {
        setNavigationConstraint()
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(30)
        }
//        resendEmailButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().inset(10)
//            make.centerY.equalToSuperview()
//        }
        errorMessage.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(6)
        }
        codeTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(34)
        }
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
    func setNavigationConstraint() {
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
