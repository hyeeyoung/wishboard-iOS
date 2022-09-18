//
//  RegisterEmailViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/19.
//

import UIKit

class RegisterEmailViewController: UIViewController {
    var registerEmailView: RegisterEmailView!
    var email: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        registerEmailView = RegisterEmailView()
        self.view.addSubview(registerEmailView)
        
        registerEmailView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        registerEmailView.emailTextField.addTarget(self, action: #selector(emailTextFieldEditingChanged(_:)), for: .editingChanged)
        registerEmailView.loginButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc func emailTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.email = text
        self.checkValidEmail(self.email)
    }
    @objc func nextButtonDidTap() {
        print("clicked!")
    }
    // MARK: - Functions
    func checkValidEmail(_ email: String) {
        let isValid = self.email.checkEmail(str: self.email)
        if isValid {
            self.registerEmailView.loginButton.then{
                $0.defaultButton("다음", .wishboardGreen, .black)
                $0.isEnabled = true
            }
        } else {
            self.registerEmailView.loginButton.then{
                $0.defaultButton("다음", .wishboardDisabledGray, .black)
                $0.isEnabled = false
            }
        }
    }
}
