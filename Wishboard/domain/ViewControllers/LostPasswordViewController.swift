//
//  LostPasswordViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/20.
//

import UIKit

class LostPasswordViewController: UIViewController {
    var lostPasswordView: LostPasswordView!
    var email: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        lostPasswordView = LostPasswordView()
        self.view.addSubview(lostPasswordView)
        
        lostPasswordView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        lostPasswordView.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        lostPasswordView.emailTextField.addTarget(self, action: #selector(emailTextFieldEditingChanged(_:)), for: .editingChanged)
        lostPasswordView.getEmailButton.addTarget(self, action: #selector(getEmailButtonDidTap), for: .touchUpInside)
    }
    override func viewDidAppear(_ animated: Bool) {
        lostPasswordView.emailTextField.becomeFirstResponder()
    }
    // MARK: - Actions
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    @objc func emailTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.email = text
        self.checkValidEmail(self.email)
    }
    @objc func getEmailButtonDidTap() {
        let lottieView = lostPasswordView.getEmailButton.setHorizontalLottieView(lostPasswordView.getEmailButton)
        lostPasswordView.getEmailButton.isSelected = true
        lottieView.isHidden = false
        lottieView.loopMode = .repeat(2)
        lottieView.play { completion in
            let getEmailVC = GetEmailViewController()
            getEmailVC.modalPresentationStyle = .fullScreen
            self.present(getEmailVC, animated: true, completion: nil)
        }
        
    }
    // MARK: - Functions
    func checkValidEmail(_ email: String) {
        let isValid = self.email.checkEmail()
        if isValid {
            self.lostPasswordView.getEmailButton.then{
                $0.defaultButton("인증메일 받기", .wishboardGreen, .black)
                $0.isEnabled = true
            }
            self.lostPasswordView.errorMessage.isHidden = true
        } else {
            self.lostPasswordView.getEmailButton.then{
                $0.defaultButton("인증메일 받기", .wishboardDisabledGray, .black)
                $0.isEnabled = false
            }
            self.lostPasswordView.errorMessage.isHidden = false
        }
    }
}
