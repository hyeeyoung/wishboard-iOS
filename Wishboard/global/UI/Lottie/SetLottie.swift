//
//  Lottie.swift
//  Wishboard
//
//  Created by gomin on 2022/09/21.
//

import Foundation
import Lottie
import UIKit

class SetLottie {
    let horizontalBlackView = LottieAnimationView(name: "loading_horizontal_black")
    let spinView = LottieAnimationView(name: "loading_spin")
    
    init() {
        horizontalBlackView.tag = 51
        spinView.tag = 52
    }
    func setSpinLottie(viewcontroller: UIViewController) -> LottieAnimationView {
        viewcontroller.view.addSubview(spinView)
        spinView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerY.centerX.equalToSuperview()
        }
        return spinView
    }
}
