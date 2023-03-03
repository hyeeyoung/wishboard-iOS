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
        super.navigationTitle.text = "가입하기"
        
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
        let lottieView = registerPWView.registerButton.setHorizontalLottieView(registerPWView.registerButton)
        registerPWView.registerButton.isSelected = true
        lottieView.isHidden = false
        lottieView.play { completion in
            self.view.endEditing(true)
            let registerInput = RegisterInput(email: self.email, password: self.pw)
            RegisterDataManager().registerDataManager(registerInput, self)
        }
    }
    // MARK: - Functions
    func checkValidPW(_ pw: String) {
        let isValid = self.pw.checkPassword()
        if isValid {
            registerPWView.errorMessage.isHidden = true
            registerPWView.registerButton.then{
                $0.defaultButton("가입하기", .wishboardGreen, .black)
                $0.isEnabled = true
            }
        } else {
            registerPWView.errorMessage.isHidden = false
            registerPWView.registerButton.then{
                $0.defaultButton("가입하기", .wishboardDisabledGray, .dialogMessageColor)
                $0.isEnabled = false
            }
        }
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
        
        // FCM
        sendFCM()
        // go main
        ScreenManager().goMain(self)
    }
    // MARK: FCM API
    func sendFCM() {
        // Send FCM token to server
        let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? ""
        print("device Token:", deviceToken)
        let fcmInput = FCMInput(fcm_token: deviceToken)
        FCMDataManager().fcmDataManager(fcmInput, self)
    }
    func fcmAPISuccess(_ result: APIModel<TokenResultModel>) {
        print(result.message)
    }
}
