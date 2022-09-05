//
//  LoginViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = LoginView()
        view.backgroundColor = .white
        
        let viewModel = LoginViewModel(self)
        self.view.addSubview(view)
        
        view.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        
        view.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    // MARK: - Actions
    @objc func backBtnDidTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
