//
//  String.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import Foundation

extension String {
    func checkEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    func checkPassword() -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}" // 8자리 ~ 50자리 영어+숫자+특수문자
        return  NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}
