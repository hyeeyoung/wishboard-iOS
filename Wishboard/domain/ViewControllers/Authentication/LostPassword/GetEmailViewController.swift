//
//  GetEmailViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/20.
//

import UIKit
import Lottie

class GetEmailViewController: KeyboardViewController {
    var getEmailView: GetEmailView!
    var lottieView: LottieAnimationView!
    
    // 인증번호 Properties
    var authCode: String?
    var code: String = ""
    var email: String?
    // Timer Properties
    var isValidTime: Bool = true
    var timer: Timer!
    let timeSelector: Selector = #selector(updateTime)
    let interval = 1.0
    var timerCount = 299

    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = Title.loginByEmail
        
        setGetEmailView()
    }
}
extension GetEmailViewController {
    func setGetEmailView() {
        getEmailView = GetEmailView()
        self.view.addSubview(getEmailView)
        
        getEmailView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        
        getEmailView.codeTextField.addTarget(self, action: #selector(codeTextFieldEditingChanged(_:)), for: .editingChanged)
        getEmailView.loginButtonKeyboard.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        getEmailView.loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        
        super.textfield = getEmailView.codeTextField
        // Timer
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
    }
}
extension GetEmailViewController {
    // MARK: - Actions
    @objc func codeTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        let trimString = text.trimmingCharacters(in: .whitespaces)
        self.getEmailView.codeTextField.text = trimString
        self.code = trimString
        self.checkValidCode()
    }
    @objc func loginButtonDidTap() {
        UIDevice.vibrate()
        if self.code != self.authCode {
            getEmailView.messageLabel.isHidden = false
            self.getEmailView.loginButtonKeyboard.isActivate = false
            self.getEmailView.loginButton.isActivate = false
        } else {
            lottieView = getEmailView.codeTextField.isFirstResponder ? getEmailView.loginButtonKeyboard.setLottieView() : getEmailView.loginButton.setLottieView()
            lottieView.play { completion in
                let fcmToken = UserManager.deviceToken ?? ""
                let lostPasswordInput = LostPasswordInput(verify: true, email: self.email!, fcmToken: fcmToken)
                LostPasswordDataManager().verifyCodeDataManager(lostPasswordInput, self)
            }
        }
    }
    @objc func updateTime() {
        //남은 분
        var minutes = self.timerCount / 60
        //그러고도 남은 초
        var seconds = self.timerCount % 60
        getEmailView.timerLabel.text = "\(minutes):\(seconds)"
        if timerCount > 0 {timerCount = timerCount - 1}
        else {
            timer.invalidate()
            timerCount = 0
            isValidTime = false
            checkValidCode()
        }
    }
    // MARK: - Functions
    func checkValidCode() {
        let codeCount = self.code.count ?? 0
        var isValidCode = codeCount > 0 ? true : false
        if isValidCode && self.isValidTime {
            self.getEmailView.messageLabel.isHidden = true
            self.getEmailView.loginButtonKeyboard.isActivate = true
            self.getEmailView.loginButton.isActivate = true
        } else {
            self.getEmailView.loginButtonKeyboard.isActivate = false
            self.getEmailView.loginButton.isActivate = false
        }
    }
}
// MARK: - API Success
extension GetEmailViewController {
    func verifyCodeAPISuccess(_ result: APIModel<VerifyCodeModel>) {
        let accessToken = result.data?.token.accessToken
        let refreshToken = result.data?.token.refreshToken
        let email = self.email
        
        UserManager.accessToken = accessToken
        UserManager.refreshToken = refreshToken
        UserManager.isFirstLogin = false
        UserManager.email = email
        if let tempNickname = result.data?.tempNickname {
            UserManager.tempNickname = tempNickname
        }
        
        ScreenManager().goMain(self)
        
        print(result)
    }
}
