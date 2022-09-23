//
//  Lottie.swift
//  Wishboard
//
//  Created by gomin on 2022/09/21.
//

import Foundation
import Lottie

class SetLottie {
    let horizontalBlackView = AnimationView(name: "loading_horizontal_black")
    let spinView = AnimationView(name: "loading_spin")
    
    init() {
        horizontalBlackView.tag = 51
        spinView.tag = 52
    }
    
}
