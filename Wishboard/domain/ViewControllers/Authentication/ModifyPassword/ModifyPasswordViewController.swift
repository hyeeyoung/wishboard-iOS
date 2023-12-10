//
//  ModifyPasswordViewController.swift
//  Wishboard
//
//  Created by gomin on 2023/03/29.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ModifyPasswordViewController: TitleCenterViewController {
    var observer = UserObserver.shared
    
    let modifyPasswordView = ModifyPasswordView()
    var passwordInput: String?
    var passwordRewriteInput: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = Title.modifyPassword

        self.view.addSubview(modifyPasswordView)
        modifyPasswordView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        
        setUpTextField()
        setUpButton()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    /// will disappear
    override func viewWillDisappear(_ animated: Bool) {
        // 화면이 사라질 때 마이페이지에 nil 전달
        // 이유: 마이페이지에서 어떤 값을 전달받아도 TabBar를 보여주게 작동
        observer.notify(nil)
    }
    // MARK: - Set Up
    func setUpTextField() {
        modifyPasswordView.newPasswordTextField.addTarget(self, action: #selector(newPasswordTextFieldEditingChanged), for: .editingChanged)
        modifyPasswordView.passwordRewriteTextField.addTarget(self, action: #selector(passwordRewriteTextFieldEditingChanged), for: .editingChanged)
        
        modifyPasswordView.newPasswordTextField.delegate = self
        modifyPasswordView.passwordRewriteTextField.delegate = self
    }
    func setUpButton() {
        modifyPasswordView.completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
        modifyPasswordView.completeButtonKeyboard.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }
    // MARK: - Actions
    @objc func newPasswordTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.passwordInput = text
        isValid()
    }
    @objc func passwordRewriteTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.passwordRewriteInput = text
        isValid()
    }
    @objc func completeButtonDidTap() {
        modifyPasswordView.completeButton.isEnabled = false
        UIDevice.vibrate()
        self.view.endEditing(true)
        
        self.modifyPassword(pw: self.passwordInput ?? "")
        
        // 지정된 시간 후에 버튼 다시 활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.modifyPasswordView.completeButton.isEnabled = true
        }
    }
    //MARK: - Methods
    private func isValidPassword(_ pw: String) -> Bool {
        let pwRegEx = RegularExpression.password
        let pwTest = NSPredicate(format:"SELF MATCHES %@", pwRegEx)
        
        var errorMessageHidden = pw == "" || pwTest.evaluate(with: pw)
        modifyPasswordView.newPasswordErrorMessageLabel.isHidden = errorMessageHidden
        errorMessageHidden ? modifyPasswordView.intervalConstraint?.update(offset: 32) : modifyPasswordView.intervalConstraint?.update(offset: 50)
        
        return pwTest.evaluate(with: pw) ? true : false
    }
    private func isPasswordSame(_ pwr: String) -> Bool {
        modifyPasswordView.passwordRewriteErrorMessageLabel.isHidden = pwr == "" || pwr == self.passwordInput ? true : false
        
        return pwr == self.passwordInput ? true : false
    }
    private func isValid() {
        if isValidPassword(self.passwordInput ?? "") && isPasswordSame(self.passwordRewriteInput ?? "") {
            self.modifyPasswordView.completeButton.isActivate = true
            self.modifyPasswordView.completeButtonKeyboard.isActivate = true
        } else {
            self.modifyPasswordView.completeButton.isActivate = false
            self.modifyPasswordView.completeButtonKeyboard.isActivate = false
        }
    }
}
// TODO: API
// MARK: - API Success
extension ModifyPasswordViewController {
    func loginAPIFail() {
        for completeButton in [self.modifyPasswordView.completeButton, self.modifyPasswordView.completeButtonKeyboard] {
            completeButton.isActivate = false
        }
    }
    
    private func modifyPassword(pw: String){
        UserService.shared.modifyPassword(pw: pw) { result in
            switch result {
                case .success(let data):
                if data.success {
                    print("비밀번호 변경 성공 by moya")
                    // 마이페이지에 노티를 준다.
                    self.observer.notify(.passwordModified)
                    // 화면 이동
                    self.navigationController?.popViewController(animated: true)
                }
                    
                    break
            case .failure(let error):
                print(error.localizedDescription)
//                if let statusCode = error.responseCode {
//                    switch statusCode {
//                    case 400, 204:
//                        self.loginAPIFail()
//                    case 500:
//                       DispatchQueue.main.async {
//                           ErrorBar(self)
//                       }
//                    default:
//                        print(statusCode)
//                    }
//                }
            default:
                break
            }
        }
    }
}
extension ModifyPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
