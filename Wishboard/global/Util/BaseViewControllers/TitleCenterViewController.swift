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
            make.width.height.equalTo(44)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
