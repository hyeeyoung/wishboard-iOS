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
        super.navigationTitle.text = "가입하기"
        
        registerEmailView = RegisterEmailView()
        self.view.addSubview(registerEmailView)
        
        registerEmailView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        registerEmailView.emailTextField.addTarget(self, action: #selector(emailTextFieldEditingChanged(_:)), for: .editingChanged)
        registerEmailView.nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        
        super.textfield = registerEmailView.emailTextField
    }
    // MARK: - Actions
    @objc func emailTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.email = text
        self.checkValidEmail(self.email)
    }
    @objc func nextButtonDidTap() {
        self.view.endEditing(true)
        let checkEmailInput = CheckEmailInput(email: self.email)
        RegisterDataManager().checkEmailDataManager(checkEmailInput, self)
    }
    // MARK: - Functions
    func checkValidEmail(_ email: String) {
        let isValid = self.email.checkEmail()
        if isValid {
            self.registerEmailView.nextButton.then{
                $0.defaultButton("다음", .wishboardGreen, .black)
                $0.isEnabled = true
            }
        } else {
            self.registerEmailView.nextButton.then{
                $0.defaultButton("다음", .wishboardDisabledGray, .black)
                $0.isEnabled = false
            }
        }
    }
}
// MARK: - API Success
extension RegisterEmailViewController {
    func checkEmailAPISuccess(_ result: APIModel<ResultModel>) {
        let registerVC = RegisterPasswordViewController(title: "2/2단계")
        registerVC.email = self.email
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    func checkEmaiAPIFail() {
        SnackBar(self, message: .checkEmail)
    }
}
