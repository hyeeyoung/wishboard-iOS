//
//  String.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import Foundation

extension String {
    func checkEmail(str: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: str)
    }
}
