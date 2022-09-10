//
//  HowToViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class HowToViewController: UIViewController {
    var howToView: HomeBottomSheetView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        howToView = HomeBottomSheetView()
        self.view.addSubview(howToView)
        
        howToView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(-41)
        }
        self.view.roundCornersDiffernt(topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0)
        
        howToView.okButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    @objc func goBack() {
        self.dismiss(animated: true)
    }
}
