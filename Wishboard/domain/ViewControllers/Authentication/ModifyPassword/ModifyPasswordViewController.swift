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
    let modifyPasswordView = ModifyPasswordView()
    var passwordInput: String?
    var passwordRewriteInput: String?
    var preVC: MyPageViewController!
    var modified: Bool = false
    
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
    override func viewDidDisappear(_ animated: Bool) {
        if modified {
            preVC.isPasswordModified = true
            MypageDataManager().getUserInfoDataManager(preVC)
        }
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
        UIDevice.vibrate()
        self.view.endEditing(true)
        
        self.modifyPassword(pw: self.passwordInput ?? "")
    }
    //MARK: - Methods
    private func isValidPassword(_ pw: String) -> Bool {
        let pwRegEx = RegularExpression.password
        let pwTest = NSPredicate(format:"SELF MATCHES %@", pwRegEx)
        
        modifyPasswordView.newPasswordErrorMessageLabel.isHidden = pw == "" || pwTest.evaluate(with: pw) ? true : false
        
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
//        SnackBar(self, message: .login)
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
                    self.modified = true
                    // 화면 이동
                    self.navigationController?.popViewController(animated: true)
//                    ScreenManager().goMainPages(4, self, family: .passwordModified)
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
