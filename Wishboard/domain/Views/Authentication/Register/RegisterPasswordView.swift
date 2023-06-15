//
//  RegisterPasswordView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/19.
//

import Foundation
import UIKit
import SafariServices

class RegisterPasswordView: UIView {
    // MARK: - View
    let lockedImage = UIImageView().then{
        $0.image = Image.locked
    }
    let subTitleLabel = DefaultLabel().then{
        $0.text = Message.password
        $0.setTypoStyleWithMultiLine(typoStyle: .SuitD2)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    var pwTextField = DefaultTextField(Placeholder.password).then{
        $0.becomeFirstResponder()
        $0.isSecureTextEntry = true
    }
    let errorMessage = UILabel().then{
        $0.text = ErrorMessage.password
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
        $0.textColor = .pink_700
    }
    let stack = UIStackView().then{
        $0.axis = .horizontal
        $0.spacing = 0
    }
    let registerButton = DefaultButton(titleStr: Button.register)
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 100.0))
    }()
    // MARK: - Life Cycles
    var preVC: RegisterPasswordViewController!
    override init(frame: CGRect) {
        super.init(frame: frame)

        pwTextField.inputAccessoryView = accessoryView // <-
        
        setUpView()
        setUpConstraint()
        
        self.errorMessage.isHidden = true
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func terClicked() {
        ScreenManager().linkTo(viewcontroller: preVC, "\(Storage().BaseURL)/terms.html")
    }
    // MARK: - Functions
    func setUpView() {
        addSubview(lockedImage)
        addSubview(subTitleLabel)
        addSubview(pwTextField)
        addSubview(errorMessage)
        
        accessoryView.addSubview(registerButton)
        accessoryView.addSubview(stack)
        setStackView()
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
        pwTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(42)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(32)
        }
        errorMessage.snp.makeConstraints { make in
            make.leading.trailing.equalTo(pwTextField)
            make.top.equalTo(pwTextField.snp.bottom).offset(5)
        }
        registerButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(16)
        }
        stack.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.bottom.equalTo(registerButton.snp.top).offset(-5)
            make.centerX.equalToSuperview()
        }
    }
    func setStackView() {
        setLabel("가입 시 ")
        let termButton = setUnderLinedButton("이용약관")
        setLabel(" 및 ")
        let privacyTermButton = setUnderLinedButton("개인정보 처리방침")
        setLabel("에 동의하는 것으로 간주합니다.")
        
        termButton.addTarget(self, action: #selector(termButtonDidTap), for: .touchUpInside)
        privacyTermButton.addTarget(self, action: #selector(privacyButtonDidTap), for: .touchUpInside)
    }
    @objc func termButtonDidTap() {
        UIDevice.vibrate()
        
        self.moveToWebVC(Storage().useTermURL, "이용약관")
    }
    @objc func privacyButtonDidTap() {
        UIDevice.vibrate()
        
        self.moveToWebVC(Storage().privacyTermURL, "개인정보 처리방침")
    }
}

extension RegisterPasswordView {
    func setLabel(_ title: String) {
        let label = UILabel().then{
            $0.text = title
            $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
            $0.textColor  = .gray_300
        }
        stack.addArrangedSubview(label)
    }
    func setUnderLinedButton(_ title: String) -> UIButton {
        let underlineButton = UIButton().then{
            $0.setUnderline(title, .green_700, TypoStyle.SuitB4.font)
        }
        stack.addArrangedSubview(underlineButton)
        return underlineButton
    }
    // MARK: move to link
    func moveToWebVC(_ link: String, _ title: String) {
        let vc = WebViewController()
        vc.webURL = link
        vc.setUpTitle(title)
        
        self.preVC.navigationController?.pushViewController(vc, animated: true)
    }
}
