//
//  DefaultTextField.swift
//  Wishboard
//
//  Created by gomin on 2023/03/19.
//

import Foundation
import UIKit

class DefaultTextField: UITextField {
    
    init(_ placeholder: String) {
        super.init(frame: CGRect.zero)
        
        self.placeholder = placeholder
        self.font = UIFont.Suit(size: 16, family: .Regular)
        self.textColor = .editTextFontColor
        
        self.backgroundColor = .wishboardTextfieldGray
        self.layer.cornerRadius = 6
        self.autocapitalizationType = .none
        
        self.addLeftPadding(10)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
