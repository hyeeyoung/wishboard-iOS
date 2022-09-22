//
//  SnackBar.swift
//  Wishboard
//
//  Created by gomin on 2022/09/23.
//

import Foundation
import UIKit

class SnackBar {
    let backgroundView = UIView().then{
        $0.backgroundColor = .black
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    var title = UILabel().then{
        $0.textColor = .white
        $0.font = UIFont.Suit(size: 14, family: .Regular)
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }
    
    init(_ originView: UIViewController, _ titleStr: String) {
        title.text = titleStr
        backgroundView.addSubview(title)
        
        // 만약 하단바가 존재할 때
        if (originView.tabBarController != nil) {
            originView.tabBarController?.tabBar.addSubview(backgroundView)
        } else {
            originView.view.addSubview(backgroundView)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(47)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(47)
        }
        title.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.5) {
            self.backgroundView.transform = CGAffineTransform(translationX: 0, y: -81)
        } completion: { finished in
            UIView.animate(withDuration: 0.5, delay: 2.5) {
                self.backgroundView.transform = .identity
            }
        }

    }
}
