//
//  LoginViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    let loginView = LoginView()
    private let loginViewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginView.backgroundColor = .white
        self.view.addSubview(loginView)
        
        loginView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        loginView.emailTextField.addTarget(self, action: #selector(emailTextFieldEditingChanged), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldEditingChanged), for: .editingChanged)
        
        loginView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        bind()
    }
    // MARK: - Actions
    @objc func backBtnDidTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @objc func emailTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        loginViewModel.emailTextFieldEditingChanged(text)
    }
    @objc func passwordTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        loginViewModel.passwordTextFieldEditingChanged(text)
    }
    //MARK: - Methods
    private func bind() {
        loginViewModel.isValidID.bind { isValidID in
            guard let isValid = isValidID else {return}
            if isValid {
                self.loginView.loginButton.defaultButton("로그인하기", UIColor.SignatureColor())
            } else {
                self.loginView.loginButton.defaultButton("로그인하기", UIColor.DisabledColor())
            }
        }

    }
}
