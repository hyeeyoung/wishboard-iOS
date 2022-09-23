//
//  LoginViewModel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import Foundation
import UIKit

class LoginViewModel {
    var email: String?
    var password: String?
    var isValidEmail: Bool = false
    var isValidPassword: Bool = false
    var isValidID: Observable<Bool?> = Observable(nil)
    
    init() {
        
    }
    func emailTextFieldEditingChanged(_ text : String) {
        self.email = text

        if self.email?.checkEmail() == true {
            isValidEmail = true
        } else {
            isValidEmail = false
        }
        isValid()
    }
    func passwordTextFieldEditingChanged(_ text : String) {
        self.password = text
        
        if self.password!.count > 0 {
            isValidPassword = true
        } else {
            isValidPassword = false
        }
        isValid()
    }
    func isValid() {
        if isValidEmail && isValidPassword {
            isValidID.value = true
        } else {
            isValidID.value = false
        }
    }
}
