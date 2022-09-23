//
//  GetEmailViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/20.
//

import UIKit
import Lottie

class GetEmailViewController: UIViewController {
    var getEmailView: GetEmailView!
    var isValidTime: Bool = true
    var code: String = ""
    // Timer Properties
    var timer: Timer!
    let timeSelector: Selector = #selector(updateTime)
    let interval = 1.0
    var timerCount = 299

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        setGetEmailView()
    }
}
extension GetEmailViewController {
    func setGetEmailView() {
        getEmailView = GetEmailView()
        self.view.addSubview(getEmailView)
        
        getEmailView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        getEmailView.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        getEmailView.codeTextField.addTarget(self, action: #selector(codeTextFieldEditingChanged(_:)), for: .editingChanged)
        getEmailView.loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        
        // Timer
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
    }
}
extension GetEmailViewController {
    // MARK: - Actions
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    @objc func codeTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.code = text
        self.checkValidCode()
    }
    @objc func loginButtonDidTap() {
        let lottieView = getEmailView.loginButton.setHorizontalLottieView(getEmailView.loginButton)
        getEmailView.loginButton.isSelected = true
        lottieView.isHidden = false
        lottieView.loopMode = .loop
        lottieView.play()
//        lottieView.play { completion in
//            let getEmailVC = GetEmailViewController()
//            getEmailVC.modalPresentationStyle = .fullScreen
//            self.present(getEmailVC, animated: true, completion: nil)
//        }
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
            self.getEmailView.loginButton.then{
                $0.defaultButton("로그인 하기", .wishboardGreen, .black)
                $0.isEnabled = false
            }
        } else {
            self.getEmailView.loginButton.then{
                $0.defaultButton("로그인 하기", .wishboardDisabledGray, .black)
                $0.isEnabled = false
            }
        }
    }
}
