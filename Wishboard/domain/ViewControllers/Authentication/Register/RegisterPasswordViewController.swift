//
//  RegisterPasswordViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/19.
//

import UIKit
import Lottie

class RegisterPasswordViewController: KeyboardViewController {
    var registerPWView: RegisterPasswordView!
    var email: String!
    var pw: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = Title.register
        
        registerPWView = RegisterPasswordView()
        self.view.addSubview(registerPWView)
        
        registerPWView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        registerPWView.preVC = self
        registerPWView.registerButton.isEnabled = false
        registerPWView.pwTextField.addTarget(self, action: #selector(pwTextFieldEditingChanged(_:)), for: .editingChanged)
        registerPWView.registerButton.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
        
        super.textfield = registerPWView.pwTextField
        if !UIDevice.current.hasNotch {registerPWView.stack.isHidden = true}
    }
}
extension RegisterPasswordViewController {
    // MARK: - Actions
    @objc func pwTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        let trimString = text.trimmingCharacters(in: .whitespaces)
        self.registerPWView.pwTextField.text = trimString
        self.pw = trimString
        self.checkValidPW(self.pw)
    }
    @objc func registerButtonDidTap() {
        UIDevice.vibrate()
        let lottieView = registerPWView.registerButton.setLottieView()
        lottieView.play { completion in
            self.view.endEditing(true)
            let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? ""
            let registerInput = RegisterInput(email: self.email, password: self.pw, fcmToken: deviceToken)
            RegisterDataManager().registerDataManager(registerInput, self)
        }
    }
    // MARK: - Functions
    func checkValidPW(_ pw: String) {
        let isValid = self.pw.checkPassword()
        
        registerPWView.registerButton.isActivate = isValid ? true : false
        registerPWView.errorMessage.isHidden = isValid ? true : false
    }
}
// MARK: - API Success
extension RegisterPasswordViewController {
    func registerAPISuccess(_ result: APIModel<TokenResultModel>) {
        let accessToken = result.data?.token.accessToken
        let refreshToken = result.data?.token.refreshToken
        let tempNickname = result.data?.tempNickname
        
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
        UserDefaults.standard.set(true, forKey: "isFirstLogin")
        UserDefaults.standard.set(tempNickname, forKey: "tempNickname")
  
        // go main
        ScreenManager().goMain(self)
    }
}
