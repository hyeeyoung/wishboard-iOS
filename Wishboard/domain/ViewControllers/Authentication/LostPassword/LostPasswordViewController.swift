//
//  LostPasswordViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/20.
//

import UIKit

class LostPasswordViewController: KeyboardViewController {
    var lostPasswordView: LostPasswordView!
    var email: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = Title.loginByEmail
        
        lostPasswordView = LostPasswordView()
        self.view.addSubview(lostPasswordView)
        
        lostPasswordView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        lostPasswordView.emailTextField.addTarget(self, action: #selector(emailTextFieldEditingChanged(_:)), for: .editingChanged)
        lostPasswordView.getEmailButton.addTarget(self, action: #selector(getEmailButtonDidTap), for: .touchUpInside)
        
        super.textfield = lostPasswordView.emailTextField
    }
    override func viewDidAppear(_ animated: Bool) {
        lostPasswordView.emailTextField.becomeFirstResponder()
    }
    // MARK: - Actions
    @objc func emailTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        let trimString = text.trimmingCharacters(in: .whitespaces)
        self.lostPasswordView.emailTextField.text = trimString
        self.email = trimString
        self.checkValidEmail(self.email)
    }
    @objc func getEmailButtonDidTap() {
        UIDevice.vibrate()
        let checkEmailInput = CheckEmailInput(email: self.email)
        LostPasswordDataManager().checkEmailDataManager(checkEmailInput, self)
    }
    // MARK: - Functions
    func checkValidEmail(_ email: String) {
        let isValid = self.email.checkEmail()
        if isValid {
            self.lostPasswordView.getEmailButton.isActivate = true
            self.lostPasswordView.errorMessage.isHidden = true
        } else {
            self.lostPasswordView.getEmailButton.isActivate = false
            self.lostPasswordView.errorMessage.text = ErrorMessage.email
            self.lostPasswordView.errorMessage.isHidden = false
        }
    }
}
// MARK: - API Success
extension LostPasswordViewController {
    func checkEmailAPISuccess(_ result: APIModel<LostPasswordModel>) {
        let authCode = result.data?.verificationCode
        
        let getEmailVC = GetEmailViewController(title: Title.stepTwo)
        getEmailVC.authCode = authCode
        getEmailVC.email = self.email
        
        self.navigationController?.pushViewController(getEmailVC, animated: true)
        print(result)
    }
    func checkEmaiAPIFail() {
        self.lostPasswordView.errorMessage.text = ErrorMessage.nonExistAccount
        self.lostPasswordView.errorMessage.isHidden = false
        
        self.lostPasswordView.getEmailButton.isActivate = false
    }
}
