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
//        loginViewController.modalTransitionStyle = .coverVertical
        loginViewController.modalPresentationStyle = .fullScreen
        self.viewcontroller.present(loginViewController, animated: true, completion: nil)
    }
    func goToRegisterPage() {
        let registerVC = RegisterEmailViewController()
        registerVC.modalPresentationStyle = .fullScreen
        self.viewcontroller.present(registerVC, animated: true, completion: nil)
    }
}
