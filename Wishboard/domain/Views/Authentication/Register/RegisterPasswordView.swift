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
    var pwTextField = UITextField().then{
        $0.defaultTextField("비밀번호")
        $0.becomeFirstResponder()
        $0.isSecureTextEntry = true
    }
    let errorMessage = UILabel().then{
        $0.text = "8자리 이상의 영문자, 숫자, 특수 문자 조합으로 입력해주세요."
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textColor = .wishboardRed
    }
    let termLabel = UILabel().then{
        $0.numberOfLines = 0
        $0.isUserInteractionEnabled = true
        $0.textAlignment = .center
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(termLabelTapped(_:))
          )
        $0.addGestureRecognizer(recognizer)
    }
    let registerButton = UIButton().then{
        $0.defaultButton("가입하기", .wishboardDisabledGray, .black)
    }
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 72.0))
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
        
        accessoryView.addSubview(registerButton)
        accessoryView.addSubview(termLabel)
        configureLabel()
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
        registerButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(16)
        }
        termLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(registerButton.snp.top).offset(-6)
        }
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
    // Label의 특정 문자열에 밑줄 긋고 색상 변경
    func configureLabel() {
      let useTerm = "이용약관"
      let personalTerm = "개인정보 취급방침"
      let generalText = String(
        format: "가입 시 %@ 및 %@에 동의하는 것으로 간주합니다.",
        useTerm,
        personalTerm
      )

      // NSAttributedString.Key, Value 속성 정의
      let generalAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.wishboardGray,
        .font: UIFont.Suit(size: 12, family: .Regular)
      ]
      let linkAttributes: [NSAttributedString.Key: Any] = [
        .underlineStyle: NSUnderlineStyle.single.rawValue,
        .foregroundColor: UIColor.wishboardGreen,
        .font: UIFont.Suit(size: 12, family: .Regular)
      ]

      let mutableString = NSMutableAttributedString()
      
      // generalAttributes(기본 스타일) 적용
      mutableString.append(
        NSAttributedString(string: generalText,attributes: generalAttributes)
      )
        
      // 각 문자열의 range에 linkAttributes 적용
      mutableString.setAttributes(
        linkAttributes,
        range: (generalText as NSString).range(of: useTerm)
      )
      mutableString.setAttributes(
        linkAttributes,
        range: (generalText as NSString).range(of: personalTerm)
      )

        termLabel.attributedText = mutableString
    }
    // 밑줄 쳐진 특정 문자열 클릭 시
    @objc func termLabelTapped(_ sender: UITapGestureRecognizer) {
        print("clicked!!")
        //fixedLabel에서 UITapGestureRecognizer로 선택된 부분의 CGPoint를 구합니다.
        let point = sender.location(in: termLabel)
        
        // fixedLabel 내에서 문자열 google이 차지하는 CGRect값을 구해, 그 안에 point가 포함되는지를 판단합니다.
        if let userTermRect = termLabel.boundingRectForCharacterRange(subText: "google"),
           userTermRect.contains(point) {
            present(url: "https://www.google.com")
        }
        if let personalTermRect = termLabel.boundingRectForCharacterRange(subText: "github"),
           personalTermRect.contains(point) {
            present(url: "https://www.github.com")
        }
    }
    // URL 이동
    func present(url string: String) {
      if let url = URL(string: string) {
        let viewController = SFSafariViewController(url: url)
          preVC.present(viewController, animated: true)
      }
    }
}
