//
//  LoginViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class LoginViewController: TitleCenterViewController {
    // MARK: Property
    private let viewModel: LoginViewModel2 = LoginViewModel2()
    let loginView = LoginView()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = Title.login

        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        
        setUpKeyboardNotification()
        setTextFieldDelegate()
        setLostPasswordButton()
        
        bind()
    }
    
    // MARK: ViewModel bind
    private func bind() {
        
        let input = LoginViewModel2.Input(emailText: loginView.emailTextField.rx.text.orEmpty.asObservable(),
                                          passwordText: loginView.passwordTextField.rx.text.orEmpty.asObservable(),
                                          loginButtonEvent: loginView.loginButton.rx.tap)
        
        let output = viewModel.transform(input)
        
        // 로그인 버튼 활성화 유무
        output.buttonActivate
            .drive(loginView.loginButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        // 이메일과 비밀번호 입력값의 띄어쓰기 제거
        output.processEmailText
            .bind(to: loginView.emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.processPwText
            .bind(to: loginView.passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 로그인 api 호출 후 분기처리
        output.loginResponse
            .subscribe(onNext: {
                if $0 {self.moveToMain()}
                else {self.loginAPIFail()}
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - UI 관련 extension
extension LoginViewController {
    /// 키보드 Notification 설정 - 키보드 올라오고 내려갈 때 호출
    func setUpKeyboardNotification() {
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        
        setUpButtonLocation(keyboardWillShow, keyboardWillHide)
    }
    /// 키보드 여부에 따른 버튼 위치 조정
    func setUpButtonLocation(_ keyboardWillShow: Observable<Foundation.Notification>, _ keyboardWillHide: Observable<Foundation.Notification>) {
        // 버튼의 위치 Observable 생성
        let buttonPosition = Observable
            .merge(keyboardWillShow, keyboardWillHide)
            .map { notification -> CGFloat in
                // 키보드가 나타날 때
                if notification.name == UIResponder.keyboardWillShowNotification {
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        return -keyboardFrame.height - 16 // 키보드가 나타날 때 버튼 위치 조정
                    }
                }
                return -34 // 키보드가 사라질 때 버튼 위치 초기화
            }
        
        // 비밀번호를 잊어버렸나요? 버튼 하단 constraint 정의 및 위치 업데이트
        // 로그인 버튼이 위 버튼을 기준으로 위치조정이 되어있기 때문
        var buttonBottomConstraint: Constraint?
        loginView.lostPasswordButton.snp.makeConstraints { make in
            buttonBottomConstraint = make.bottom.equalToSuperview().offset(-34).constraint
        }
        updateButtonPosition(buttonPosition, buttonBottomConstraint)
    }
    /// 버튼 위치를 업데이트
    func updateButtonPosition(_ buttonPosition: Observable<CGFloat>, _ buttonBottomConstraint: Constraint?) {
        buttonPosition
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] offset in
                buttonBottomConstraint?.update(offset: offset)
                self?.view.layoutIfNeeded() // 업데이트된 제약 조건을 즉시 적용
            })
            .disposed(by: disposeBag)
    }
    /// 이메일, 비밀번호 텍스트필드 Delegate 설정
    func setTextFieldDelegate() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    /// 비밀번호를 잊으셨나요? 버튼 클릭 시 화면 이동
    func setLostPasswordButton() {
        loginView.lostPasswordButton.rx.tap
            .subscribe{ [weak self] _ in
                self?.lostPasswordButtonDidTap()
            }.disposed(by: disposeBag)
    }
    func lostPasswordButtonDidTap() {
        UIDevice.vibrate()
        let lostPwVC = LostPasswordViewController(title: "1/2 단계")
        navigationController?.pushViewController(lostPwVC, animated: true)
    }
}

// MARK: - api 관련
extension LoginViewController {
    /// 로그인 성공 후 메인 화면으로 이동
    func moveToMain() {
        guard let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarViewController") as? UITabBarController else {fatalError()}
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    /// 로그인 실패했을 때
    func loginAPIFail() {
        SnackBar.shared.showSnackBar(self, message: .login)
        loginView.loginButton.isActivate = false
    }
}
// MARK: Textfield delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
