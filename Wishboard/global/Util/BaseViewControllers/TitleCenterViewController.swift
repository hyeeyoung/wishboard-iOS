//
//  TitleCenterViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/10/01.
//

import UIKit

class TitleCenterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.addSubview(navigationTitle)
        navigationView.addSubview(backBtn)
        
        navigationTitle.snp.makeConstraints{
            $0.centerY.centerX.equalToSuperview()
        }
        backBtn.snp.makeConstraints{ make in
            make.width.equalTo(backBtn.snp.height)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }

}
