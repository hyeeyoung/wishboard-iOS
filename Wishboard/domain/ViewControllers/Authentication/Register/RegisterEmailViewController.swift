//
//  RegisterEmailViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/19.
//

import UIKit

class RegisterEmailViewController: KeyboardViewController {
    var registerEmailView: RegisterEmailView!
    var email: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = Title.register
        
        registerEmailView = RegisterEmailView()
        self.view.addSubview(registerEmailView)
        
        registerEmailView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        registerEmailView.emailTextField.addTarget(self, action: #selector(emailTextFieldEditingChanged(_:)), for: .editingChanged)
        registerEmailView.nextButtonKeyboard.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        registerEmailView.nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        
        super.textfield = registerEmailView.emailTextField
    }
    // MARK: - Actions
    @objc func emailTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        let trimString = text.trimmingCharacters(in: .whitespaces)
        self.registerEmailView.emailTextField.text = trimString
        self.email = trimString
        self.checkValidEmail(self.email)
    }
    @objc func nextButtonDidTap() {
        UIDevice.vibrate()
        let checkEmailInput = CheckEmailInput(email: self.email)
        RegisterDataManager().checkEmailDataManager(checkEmailInput, self)
    }
    // MARK: - Functions
    func checkValidEmail(_ email: String) {
        let isValid = self.email.checkEmail()
         isValid ? self.registerEmailView.nextButtonKeyboard.activateButton() : self.registerEmailView.nextButtonKeyboard.inactivateButton()
        isValid ? self.registerEmailView.nextButton.activateButton() : self.registerEmailView.nextButton.inactivateButton()
    }
}
// MARK: - API Success
extension RegisterEmailViewController {
    func checkEmailAPISuccess(_ result: APIModel<TokenResultModel>) {
        self.view.endEditing(true)
        
        let registerVC = RegisterPasswordViewController(title: "2/2 단계")
        registerVC.email = self.email
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    func checkEmaiAPIFail() {
        self.registerEmailView.errorMessageLabel.isHidden = false
        self.registerEmailView.nextButtonKeyboard.inactivateButton()
        self.registerEmailView.nextButton.inactivateButton()
    }
}
