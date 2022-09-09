//
//  NavigationBar.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import Foundation
import UIKit

class NavigationBar {
    // Default navigation bar
    // 뒤로가기 버튼  + 가운데 제목
    func defaultNavigationBar(_ title: String, _ view: UIView, _ viewController: UIViewController) -> UIView {
        let navigationView = UIView()
        let pageTitle = UILabel().then{
            $0.text = "장바구니"
            $0.font = UIFont.Suit(size: 15, family: .Bold)
        }
        let backButton = UIButton().then{
            $0.setImage(UIImage(named: "goBack"), for: .normal)
        }
        
        view.addSubview(navigationView)
        navigationView.addSubview(pageTitle)
        navigationView.addSubview(backButton)
        
        navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        pageTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(18)
            make.height.equalTo(14)
            make.leading.equalToSuperview().offset(16)
        }
        
//        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        return navigationView
    }
}
