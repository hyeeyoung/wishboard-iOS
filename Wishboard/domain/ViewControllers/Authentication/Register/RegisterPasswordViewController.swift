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
        registerPWView.registerButtonKeyboard.isEnabled = false
        registerPWView.registerButton.isEnabled = false
        
        registerPWView.pwTextField.addTarget(self, action: #selector(pwTextFieldEditingChanged(_:)), for: .editingChanged)
        registerPWView.registerButtonKeyboard.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
        registerPWView.registerButton.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
        
        super.textfield = registerPWView.pwTextField
        if !UIDevice.current.hasNotch {registerPWView.stackKeyboard.isHidden = true}
    }
    override func viewDidAppear(_ animated: Bool) {
        registerPWView.pwTextField.becomeFirstResponder()
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
        
        var lottieView: LottieAnimationView!
        if registerPWView.pwTextField.isFirstResponder {
            lottieView = registerPWView.registerButtonKeyboard.setLottieView()
        } else {
            lottieView = registerPWView.registerButton.setLottieView()
        }
        
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
        
        registerPWView.registerButtonKeyboard.isActivate = isValid ? true : false
        registerPWView.registerButton.isActivate = isValid ? true : false
        registerPWView.errorMessage.isHidden = isValid ? true : false
    }
}
// MARK: - API Success
extension RegisterPasswordViewController {
    func registerAPISuccess(_ result: APIModel<TokenResultModel>) {
        let accessToken = result.data?.token.accessToken
        let refreshToken = result.data?.token.refreshToken
        
        UserManager.accessToken = accessToken
        UserManager.refreshToken = refreshToken
        UserManager.isFirstLogin = true
        if let tempNickname = result.data?.tempNickname {
            UserManager.tempNickname = tempNickname
        }
  
        // go main
        ScreenManager().goMain(self)
    }
}
