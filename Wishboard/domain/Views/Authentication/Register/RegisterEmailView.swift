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
        $0.image = Image.loveLetter
    }
    let subTitleLabel = DefaultLabel().then{
        $0.text = Message.email
        $0.setTypoStyleWithMultiLine(typoStyle: .SuitD2)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    var emailTextField = DefaultTextField(Placeholder.email).then{
        $0.keyboardType = .emailAddress
        $0.becomeFirstResponder()
    }
    let errorMessageLabel = UILabel().then{
        $0.text = ErrorMessage.existAccount
        $0.textColor = .pink_700
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
    }
    let nextButton = LoadingButton(Button.next)
    let nextButtonKeyboard = LoadingButton(Button.next)
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 72.0))
    }()
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        setUpConstraint()
        
        emailTextField.inputAccessoryView = accessoryView // <-
        errorMessageLabel.isHidden = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setUpView() {
        addSubview(heartLetterImage)
        addSubview(subTitleLabel)
        addSubview(emailTextField)
        addSubview(errorMessageLabel)
        addSubview(nextButton)
        
        accessoryView.addSubview(nextButtonKeyboard)
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
        errorMessageLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(6)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            // TODO: 여백 Check
            make.bottom.equalToSuperview().inset(34)
        }
        nextButtonKeyboard.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
