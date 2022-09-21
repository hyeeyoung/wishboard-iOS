//
//  RegisterPasswordViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/19.
//

import UIKit
import Lottie

class RegisterPasswordViewController: UIViewController {
    var registerPWView: RegisterPasswordView!
    var pw: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        registerPWView = RegisterPasswordView()
        self.view.addSubview(registerPWView)
        
        registerPWView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        registerPWView.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        registerPWView.pwTextField.addTarget(self, action: #selector(pwTextFieldEditingChanged(_:)), for: .editingChanged)
        registerPWView.registerButton.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
    }

}
extension RegisterPasswordViewController {
    // MARK: - Actions
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    @objc func pwTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.pw = text
        self.checkValidPW(self.pw)
    }
    @objc func registerButtonDidTap() {
        let lottieView = registerPWView.registerButton.setLottieView(registerPWView.registerButton)
        registerPWView.registerButton.isSelected = true
        lottieView.isHidden = false
        lottieView.loopMode = .loop
        lottieView.play { completion in
//            self.dismiss(animated: true)
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
                $0.defaultButton("가입하기", .wishboardDisabledGray, .black)
                $0.isEnabled = false
            }
        }
    }
}
