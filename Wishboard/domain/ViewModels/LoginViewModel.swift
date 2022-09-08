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
//        self.email = text
//
//        if self.checkEmail(str: self.email!) {
//            isValidEmail = true
//        } else {
//            isValidEmail = false
//        }
//        isValid()
    }
    func passwordTextFieldEditingChanged(_ text : String) {
        self.password = text
        
        if self.checkPassword(str: self.password!) {
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
    
    func checkEmail(str: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: str)
    }
    func checkPassword(str: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}" // 8자리 ~ 50자리 영어+숫자+특수문자
        return  NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
    }
}
