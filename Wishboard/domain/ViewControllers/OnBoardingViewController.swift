//
//  OnBoardingViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/05.
//

import UIKit

class OnBoardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        let view = OnBoardingView()
        view.setViewController(self)
        self.view.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
