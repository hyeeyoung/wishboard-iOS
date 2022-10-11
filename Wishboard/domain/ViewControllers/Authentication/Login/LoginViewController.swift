//
//  LoginViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: TitleCenterViewController {
    let loginView = LoginView()
    private let loginViewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = "로그인하기"

        self.view.addSubview(loginView)
        
        loginView.emailTextField.addTarget(self, action: #selector(emailTextFieldEditingChanged), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldEditingChanged), for: .editingChanged)
        loginView.loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        loginView.lostPasswordButton.addTarget(self, action: #selector(lostPasswordButtonDidTap), for: .touchUpInside)
        
        loginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        bind()
    }
    // MARK: - Actions
    @objc func emailTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        loginViewModel.emailTextFieldEditingChanged(text)
    }
    @objc func passwordTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        loginViewModel.passwordTextFieldEditingChanged(text)
    }
    @objc func loginButtonDidTap() {
        self.view.endEditing(true)
        let email = loginViewModel.email
        let pw = loginViewModel.password
        let loginInput = LoginInput(email: email, password: pw)
        LoginDataManager().loginDataManager(loginInput, self)
    }
    @objc func lostPasswordButtonDidTap() {
        let lostPwVC = LostPasswordViewController()
        self.navigationController?.pushViewController(lostPwVC, animated: true)
    }
    //MARK: - Methods
    private func bind() {
        loginViewModel.isValidID.bind { isValidID in
            guard let isValid = isValidID else {return}
            if isValid {
                self.loginView.loginButton.then{
                    $0.defaultButton("로그인하기", .wishboardGreen, .black)
                    $0.isEnabled = true
                }
                
            } else {
                self.loginView.loginButton.then{
                    $0.defaultButton("로그인하기", .wishboardDisabledGray, .black)
                    $0.isEnabled = false
                }
            }
        }

    }
}
// MARK: - API Success
extension LoginViewController {
    func loginAPISuccess(_ result: APIModel<ResultModel>) {
        let token = result.data?.token
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(false, forKey: "isFirstLogin")
        UserDefaults.standard.set(loginViewModel.email, forKey: "email")
        UserDefaults.standard.set(loginViewModel.password, forKey: "password")
        
        ScreenManager().goMain(self)
    }
    func loginAPIFail() {
        SnackBar(self, message: .login)
        self.loginView.loginButton.then{
            $0.defaultButton("로그인하기", .wishboardDisabledGray, .black)
            $0.isEnabled = false
        }
    }
}
