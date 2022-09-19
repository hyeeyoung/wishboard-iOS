//
//  GetEmailViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/20.
//

import UIKit

class GetEmailViewController: UIViewController {
    var getEmailView: GetEmailView!
    var email: String!
    var isValidEmail: Bool = true
    var code: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        getEmailView = GetEmailView()
        self.view.addSubview(getEmailView)
        
        getEmailView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        getEmailView.emailTextField.text = self.email
        
        getEmailView.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        getEmailView.emailTextField.addTarget(self, action: #selector(emailTextFieldEditingChanged(_:)), for: .editingChanged)
        getEmailView.codeTextField.addTarget(self, action: #selector(codeTextFieldEditingChanged(_:)), for: .editingChanged)
        getEmailView.loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
    }
    // MARK: - Actions
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    @objc func emailTextFieldEditingChanged(_ sender: UITextField) {
        getEmailView.errorMessage.isHidden = false
        let text = sender.text ?? ""
        self.email = text
        self.isValidEmail = self.checkValidEmail(self.email)
    }
    @objc func codeTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.code = text
        self.checkValidCode()
    }
    @objc func loginButtonDidTap() {
        let registerVC = RegisterPasswordViewController()
        registerVC.modalPresentationStyle = .fullScreen
        self.present(registerVC, animated: true, completion: nil)
    }
    // MARK: - Functions
    func checkValidEmail(_ email: String) -> Bool {
        let isValid = self.email.checkEmail()
        if isValid {
            self.getEmailView.resendEmailButton.then{
                $0.resendButton(.wishboardGreen)
                $0.isEnabled = true
            }
            self.getEmailView.errorMessage.isHidden = true
            return true
        } else {
            self.getEmailView.resendEmailButton.then{
                $0.resendButton(.wishboardDisabledGray)
                $0.isEnabled = false
            }
            self.getEmailView.errorMessage.isHidden = false
            return false
        }
    }
    func checkValidCode() {
        var isValidCode = self.code.count > 0 ? true : false
        if self.isValidEmail && isValidCode {
            self.getEmailView.loginButton.then{
                $0.defaultButton("로그인 하기", .wishboardGreen, .black)
                $0.isEnabled = false
            }
        } else {
            self.getEmailView.loginButton.then{
                $0.defaultButton("로그인 하기", .wishboardDisabledGray, .black)
                $0.isEnabled = false
            }
        }
    }
}
