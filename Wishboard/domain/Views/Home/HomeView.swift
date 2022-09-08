//
//  HomeView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import Foundation
import UIKit
import SnapKit
import Then

class HomeView: UIView {
    // Navigation Views
    let navigationView = UIView()
    let logo = UIImageView().then{
        $0.image = UIImage(named: "WishBoardLogo")
    }
    let cartButton = UIButton().then{
        $0.setImage(UIImage(named: "cart"), for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpView()
        setUpConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(navigationView)
        
        navigationView.addSubview(logo)
        navigationView.addSubview(cartButton)
    }
    func setUpNavigationConstraint() {
        navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        logo.snp.makeConstraints { make in
            make.width.equalTo(145)
            make.height.equalTo(19)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        cartButton.snp.makeConstraints { make in
            make.width.equalTo(23)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
    }
}
