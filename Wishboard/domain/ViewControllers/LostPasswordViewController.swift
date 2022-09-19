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
    // MARK: - Actions
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    @objc func emailTextFieldEditingChanged(_ sender: UITextField) {
        lostPasswordView.errorMessage.isHidden = false
        let text = sender.text ?? ""
        self.email = text
        self.checkValidEmail(self.email)
    }
    @objc func getEmailButtonDidTap() {
        let registerVC = RegisterPasswordViewController()
        registerVC.modalPresentationStyle = .fullScreen
        self.present(registerVC, animated: true, completion: nil)
    }
    // MARK: - Functions
    func checkValidEmail(_ email: String) {
        let isValid = self.email.checkEmail()
        if isValid {
            self.lostPasswordView.getEmailButton.then{
                $0.defaultButton("인증메일 받기", .wishboardGreen, .black)
                $0.isEnabled = true
            }
        } else {
            self.lostPasswordView.getEmailButton.then{
                $0.defaultButton("인증메일 받기", .wishboardDisabledGray, .black)
                $0.isEnabled = false
            }
        }
    }
}
