//
//  RegisterEmailView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/19.
//

import Foundation
import UIKit

class RegisterEmailView: UIView {
    // MARK: - View
    let heartLetterImage = UIImageView().then{
        $0.image = UIImage(named: "love-letter")
    }
    let subTitleLabel = UILabel().then{
        $0.text = "이메일 인증으로 비밀번호를 찾을 수 있어요.\n실제 사용될 이메일로 입력해주세요!"
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.setTextWithLineHeight()
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    var emailTextField = UITextField().then{
        $0.defaultTextField("이메일")
        $0.becomeFirstResponder()
        $0.textColor = .editTextFontColor
    }
    let nextButton = UIButton().then{
        $0.defaultButton("다음", .wishboardDisabledGray, .black)
    }
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 72.0))
    }()
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        setUpConstraint()
        
        emailTextField.inputAccessoryView = accessoryView // <-
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setUpView() {
        addSubview(heartLetterImage)
        addSubview(subTitleLabel)
        addSubview(emailTextField)
        
        accessoryView.addSubview(nextButton)
    }
    func setUpConstraint() {
        heartLetterImage.snp.makeConstraints { make in
            make.height.width.equalTo(72)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(heartLetterImage.snp.bottom).offset(10)
        }
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(42)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(32)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
