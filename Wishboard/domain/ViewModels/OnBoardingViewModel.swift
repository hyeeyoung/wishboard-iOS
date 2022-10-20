//
//  OnBoardingViewModel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import Foundation

class OnBoardingViewModel {
    var viewcontroller: OnBoardingViewController!
    
    init() {
        
    }
    func setViewController(_ viewcontroller: OnBoardingViewController) {
        self.viewcontroller = viewcontroller
    }
    func goToLoginPage() {
        let loginViewController = LoginViewController()
        self.viewcontroller.navigationController?.pushViewController(loginViewController, animated: true)
    }
    func goToRegisterPage() {
        let registerVC = RegisterEmailViewController(title: "1/2 단계")
        self.viewcontroller.navigationController?.pushViewController(registerVC, animated: true)
    }
}
