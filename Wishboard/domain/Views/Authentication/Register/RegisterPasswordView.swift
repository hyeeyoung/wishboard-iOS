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
        $0.image = UIImage(named: "locked")
    }
    let subTitleLabel = UILabel().then{
        $0.text = "마지막 비밀번호 입력 단계예요!\n입력된 비밀번호로 바로 가입되니 신중히 입력해 주세요."
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.setTextWithLineHeight()
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    var pwTextField = UITextField().then{
        $0.defaultTextField("비밀번호")
        $0.becomeFirstResponder()
        $0.isSecureTextEntry = true
        $0.textColor = .editTextFontColor
    }
    let errorMessage = UILabel().then{
        $0.text = "8자리 이상의 영문자, 숫자, 특수 문자 조합으로 입력해주세요."
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textColor = .wishboardRed
    }
    let stack = UIStackView().then{
        $0.axis = .horizontal
        $0.spacing = 0
    }
    let registerButton = UIButton().then{
        $0.defaultButton("가입하기", .wishboardDisabledGray, .black)
    }
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
        ScreenManager().linkTo(viewcontroller: preVC, "https://www.wishboard.xyz/terms.html")
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
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(registerButton.snp.top).offset(-5)
        }
    }
    func setStackView() {
        setLabel("가입 시 ")
        let termButton = setUnderLinedButton("이용약관")
        setLabel(" 및 ")
        let privacyTermButton = setUnderLinedButton("개인정보 취급방침")
        setLabel("에 동의하는 것으로 간주합니다.")
        
        termButton.addTarget(self, action: #selector(termButtonDidTap), for: .touchUpInside)
        privacyTermButton.addTarget(self, action: #selector(privacyButtonDidTap), for: .touchUpInside)
    }
    @objc func termButtonDidTap() {
        ScreenManager().linkTo(viewcontroller: preVC, "https://www.wishboard.xyz/terms.html")
    }
    @objc func privacyButtonDidTap() {
        ScreenManager().linkTo(viewcontroller: preVC, "https://www.wishboard.xyz/privacy-policy.html")
    }
}

extension RegisterPasswordView {
    func setLabel(_ title: String) {
        let label = UILabel().then{
            $0.text = title
            $0.font = UIFont.Suit(size: 12, family: .Regular)
            $0.textColor  = .wishboardGray
            $0.setTextWithLineHeight()
        }
        stack.addArrangedSubview(label)
    }
    func setUnderLinedButton(_ title: String) -> UIButton {
        let underlineButton = UIButton().then{
            $0.setUnderline(title, .wishboardGreen)
        }
        stack.addArrangedSubview(underlineButton)
        return underlineButton
    }
}
