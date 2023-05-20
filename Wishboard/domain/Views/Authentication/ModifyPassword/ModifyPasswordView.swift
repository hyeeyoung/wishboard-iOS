//
//  ModifyPasswordView.swift
//  Wishboard
//
//  Created by gomin on 2023/03/29.
//

import Foundation
import UIKit
import Then
import SnapKit

class ModifyPasswordView: UIView {
    // MARK: - Views
    // 새 비밀번호 Label
    let newPasswordLabel = UILabel().then{
        $0.text = Title.newPassword
        $0.font = UIFont.Suit(size: 14, family: .Medium)
    }
    // 새 비밀번호 TextField
    let newPasswordTextField = DefaultTextField(Placeholder.email).then{
        $0.isSecureTextEntry = true
    }
    let newPasswordErrorMessageLabel = UILabel().then{
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textColor = UIColor.wishboardRed
        $0.text = ErrorMessage.password
        $0.isHidden = true
    }
    // 비밀번호 재입력 Label
    let passwordRewriteLabel = UILabel().then{
        $0.text = Title.passwordRewrite
        $0.font = UIFont.Suit(size: 14, family: .Medium)
    }
    // 비밀번호 재입력 TextField
    let passwordRewriteTextField = DefaultTextField(Placeholder.password).then{
        $0.isSecureTextEntry = true
    }
    let passwordRewriteErrorMessageLabel = UILabel().then{
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textColor = UIColor.wishboardRed
        $0.text = ErrorMessage.passwordRewrite
        $0.isHidden = true
    }
    // 완료 버튼
    let completeButton = DefaultButton(titleStr: Button.complete).then{
        $0.isActivate = false
    }
    // 키보드 Accessory
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 100.0))
    }()
    // 키보드 위 완료 버튼
    let completeButtonKeyboard = DefaultButton(titleStr: Button.complete).then{
        $0.isActivate = false
    }
    var intervalConstraint: Constraint? = nil
    
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
        newPasswordTextField.inputAccessoryView = accessoryView
        passwordRewriteTextField.inputAccessoryView = accessoryView
    }
    func setUpView() {
        addSubview(newPasswordLabel)
        addSubview(newPasswordTextField)
        addSubview(newPasswordErrorMessageLabel)
        addSubview(passwordRewriteLabel)
        addSubview(passwordRewriteTextField)
        addSubview(passwordRewriteErrorMessageLabel)
        addSubview(completeButton)
        
        accessoryView.addSubview(completeButtonKeyboard)
    }
    func setUpConstraint() {
        self.newPasswordLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(32)
        }
        self.newPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.equalTo(newPasswordLabel)
            make.centerX.equalToSuperview()
            make.top.equalTo(newPasswordLabel.snp.bottom).offset(8)
        }
        self.newPasswordErrorMessageLabel.snp.makeConstraints { make in
            make.leading.equalTo(newPasswordTextField)
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(6)
        }
        self.passwordRewriteLabel.snp.makeConstraints { make in
            self.intervalConstraint = make.top.equalTo(newPasswordTextField.snp.bottom).offset(32).constraint
//            make.top.equalTo(newPasswordTextField.snp.bottom).offset(32)
            make.leading.equalTo(newPasswordTextField)
        }
        self.passwordRewriteTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.equalTo(newPasswordLabel)
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordRewriteLabel.snp.bottom).offset(8)
        }
        self.passwordRewriteErrorMessageLabel.snp.makeConstraints { make in
            make.leading.equalTo(passwordRewriteTextField)
            make.top.equalTo(passwordRewriteTextField.snp.bottom).offset(6)
        }
        self.completeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-34)
        }
        // keyboard button
        self.completeButtonKeyboard.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
