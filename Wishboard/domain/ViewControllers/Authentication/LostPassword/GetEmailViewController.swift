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
    var isValidTime: Bool = true
    // 인증번호 Properties
    var authCode: String?
    var code: String = ""
    var email: String?
    // Timer Properties
    var timer: Timer!
    let timeSelector: Selector = #selector(updateTime)
    let interval = 1.0
    var timerCount = 299

    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = "이메일로 로그인하기"
        
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
        self.code = text
        self.checkValidCode()
    }
    @objc func loginButtonDidTap() {
        let lottieView = getEmailView.loginButton.setHorizontalLottieView(getEmailView.loginButton)
        getEmailView.loginButton.isSelected = true
        lottieView.isHidden = false
        lottieView.play { completion in
            let lostPasswordInput = LostPasswordInput(verify: true, email: self.email)
            LostPasswordDataManager().verifyCodeDataManager(lostPasswordInput, self)
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
        isValidCode = self.code == self.authCode ? true : false //인증코드가 맞을 때
        if isValidCode && self.isValidTime {
            self.getEmailView.loginButton.then{
                $0.defaultButton("로그인 하기", .wishboardGreen, .black)
                $0.isEnabled = true
            }
        } else {
            self.getEmailView.loginButton.then{
                $0.defaultButton("로그인 하기", .wishboardDisabledGray, .black)
                $0.isEnabled = false
            }
        }
    }
}
// MARK: - API Success
extension GetEmailViewController {
    func verifyCodeAPISuccess(_ result: APIModel<VerifyCodeModel>) {
        let token = result.data?.token
        let email = self.email
        let pushState = result.data?.pushState
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(false, forKey: "isFirstLogin")
        UserDefaults.standard.set(email, forKey: "email")
        
        ScreenManager().goMain(self)
        
        print(result)
    }
}
