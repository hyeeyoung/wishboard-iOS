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
    private let viewModel: LoginViewModel2 = LoginViewModel2()
    var disposeBag = DisposeBag()
    
    let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = Title.login

        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        
        setUpTextField()
        setUpButton()
        
        bind()
    }
    // MARK: - Set Up
    func setUpTextField() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    func setUpButton() {
        loginView.lostPasswordButton.addTarget(self, action: #selector(lostPasswordButtonDidTap), for: .touchUpInside)
        loginView.lostPasswordButtonKeyboard.addTarget(self, action: #selector(lostPasswordButtonDidTap), for: .touchUpInside)
    }
    // MARK: - Actions
    @objc func lostPasswordButtonDidTap() {
        UIDevice.vibrate()
        let lostPwVC = LostPasswordViewController(title: "1/2 단계")
        self.navigationController?.pushViewController(lostPwVC, animated: true)
    }
    //MARK: - Methods
    private func bind() {
        // 키보드가 올라와있을 때와 아닐 때의 버튼 구분
        let activatedButton = loginView.emailTextField.isFirstResponder || loginView.passwordTextField.isFirstResponder ? loginView.loginButtonKeyboard : loginView.loginButton
        
        let input = LoginViewModel2.Input(emailText: loginView.emailTextField.rx.text.orEmpty.asObservable(),
                                          passwordText: loginView.passwordTextField.rx.text.orEmpty.asObservable(),
                                          loginButtonEvent: activatedButton.rx.tap)
        
        let output = viewModel.transform(input)
        
        // 로그인 버튼 활성화 유무
        output.buttonActivate
            .drive(loginView.loginButton.rx.isActivate)
        
        output.buttonActivate
            .drive(loginView.loginButtonKeyboard.rx.isActivate)
        
        // 이메일과 비밀번호 입력값의 띄어쓰기 제거
        output.processEmailText
            .bind(to: loginView.emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.processPwText
            .bind(to: loginView.passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 로그인 api 호출 후 분기처리
        output.loginResponse
            .subscribe(onNext: { [self]
                if $0 {self.moveToMain()}
                else {self.loginAPIFail()}
            })
            .disposed(by: disposeBag)
    }
    /// 로그인 성공 후 메인 화면으로 이동
    func moveToMain() {
        // go Main
        guard let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarViewController") as? UITabBarController else {fatalError()}
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
}
/// api 응답 실패했을 때
extension LoginViewController {
    func loginAPIFail() {
        SnackBar(self, message: .login)
        for loginButton in [self.loginView.loginButton, self.loginView.loginButtonKeyboard] {
            loginButton.isActivate = false
        }
    }
}
/// Textfield delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
