//
//  DefaultLabel.swift
//  Wishboard
//
//  Created by gomin on 2023/06/07.
//

import Foundation
import UIKit

class DefaultLabel: UILabel {
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.textColor = .gray_700
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
