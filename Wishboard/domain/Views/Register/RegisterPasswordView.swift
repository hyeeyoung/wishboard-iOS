//
//  RegisterPasswordView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/19.
//

import Foundation
import UIKit

class RegisterPasswordView: UIView {
    // MARK: - View
    let navigationView = UIView()
    let navigationTitle = UILabel().then{
        $0.text = "가입하기"
        $0.font = UIFont.Suit(size: 15, family: .Bold)
    }
    let backBtn = UIButton().then{
        $0.setImage(UIImage(named: "goBack"), for: .normal)
    }
    let stepLabel = UILabel().then{
        $0.text = "2/2 단계"
        $0.font = UIFont.Suit(size: 14, family: .Regular)
    }
    let lockedImage = UIImageView().then{
        $0.image = UIImage(named: "locked")
    }
    let subTitleLabel = UILabel().then{
        $0.text = "마지막 비밀번호 입력 단계예요!\n입력된 비밀번호로 바로 가입되니 신중히 입력해 주세요."
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    let pwTextField = UITextField().then{
        $0.defaultTextField("비밀번호")
        $0.isSecureTextEntry = true
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
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpView()
        setUpConstraint()
        
        self.errorMessage.isHidden = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setUpView() {
        addSubview(navigationView)
        navigationView.addSubview(navigationTitle)
        navigationView.addSubview(backBtn)
        navigationView.addSubview(stepLabel)
        
        addSubview(lockedImage)
        addSubview(subTitleLabel)
        addSubview(pwTextField)
        addSubview(errorMessage)
        
        addSubview(stack)
        setStackView()
        
        addSubview(registerButton)
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        
        lockedImage.snp.makeConstraints { make in
            make.height.width.equalTo(72)
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(24)
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
        stack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pwTextField.snp.bottom).offset(39)
        }
        registerButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
            make.top.equalTo(stack.snp.bottom).offset(5)
        }
    }
    func setStackView() {
        setLabel("가입 시 ")
        setUnderLinedButton("이용약관")
        setLabel(" 및 ")
        setUnderLinedButton("개인정보 취급방침")
        setLabel("에 동의하는 것으로 간주합니다.")
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
        stepLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
extension RegisterPasswordView {
    func setLabel(_ title: String) {
        let label = UILabel().then{
            $0.text = title
            $0.font = UIFont.Suit(size: 12, family: .Regular)
            $0.textColor  = .wishboardGray
        }
        stack.addArrangedSubview(label)
    }
    func setUnderLinedButton(_ title: String) {
        let underlineButton = UIButton().then{
            $0.setUnderline(title, .wishboardGreen)
        }
        stack.addArrangedSubview(underlineButton)
    }
    
}
