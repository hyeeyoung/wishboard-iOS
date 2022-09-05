//
//  LoginViewModel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import Foundation

class LoginViewModel {
    var viewcontroller: LoginViewController!
    
    init(_ viewcontroller: LoginViewController) {
        self.viewcontroller = viewcontroller
    }
    func goBack() {
        viewcontroller.dismiss(animated: true)
    }
}
