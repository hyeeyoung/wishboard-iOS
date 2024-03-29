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
    let lockedImage = UIImageView().then{
        $0.image = Image.locked
    }
    let subTitleLabel = DefaultLabel().then{
        $0.text = Message.sendedEmail
        $0.setTypoStyleWithMultiLine(typoStyle: .SuitD2)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    // 인증코드 TextField
    var codeTextField = DefaultTextField(Placeholder.authcode).then{
        $0.becomeFirstResponder()
        $0.isSecureTextEntry = true
    }
    var timerLabel = UILabel().then{
        $0.text = Message.timer
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD2)
        $0.textColor = .pink_700
    }
    let messageLabel = UILabel().then{
        $0.text = ErrorMessage.authcode
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
        $0.textColor = .pink_700
        $0.numberOfLines = 1
    }
    // 로그인하기 버튼
    let loginButtonKeyboard = LoadingButton(Button.login)
    let loginButton = LoadingButton(Button.login)
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 72.0))
    }()
    // MARK: - Life Cylces
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpTextFields()
        setUpView()
        setUpConstraint()
        
        self.messageLabel.isHidden = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setUpTextFields() {
        codeTextField.inputAccessoryView = accessoryView // <-
    }
    func setUpView() {
        addSubview(lockedImage)
        addSubview(subTitleLabel)
        addSubview(codeTextField)
        addSubview(messageLabel)
        codeTextField.addSubview(timerLabel)
        
        addSubview(loginButton)
        
        accessoryView.addSubview(loginButtonKeyboard)
    }
    func setUpConstraint() {
        lockedImage.snp.makeConstraints { make in
            make.height.width.equalTo(72)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lockedImage.snp.bottom).offset(10)
        }
        codeTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(42)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(32)
        }
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(codeTextField)
            make.top.equalTo(codeTextField.snp.bottom).offset(6)
        }
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(34)
        }
        loginButtonKeyboard.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
