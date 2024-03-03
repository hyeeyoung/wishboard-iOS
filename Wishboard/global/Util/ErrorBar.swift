//
//  ErrorBar.swift
//  Wishboard
//
//  Created by gomin on 2023/09/24.
//

import Foundation
import UIKit

class ErrorBar {
    // MARK: - Views
    let backgroundView = UIView().then{
        $0.backgroundColor = .gray_700
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    var title = UILabel().then{
        $0.textColor = .white
        $0.setTypoStyleWithMultiLine(typoStyle: .SuitD2)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    // MARK: - Life Cycles
    // Error SnackBar (두 줄)
    init(_ originView: UIViewController) {
        title.text = ErrorMessage.fiveHundredError
        title.textAlignment = .center
        
        backgroundView.layer.cornerRadius = 35
        backgroundView.addSubview(title)
        
        // 만약 하단바가 존재할 때
        if (originView.tabBarController?.tabBar.isHidden == false) {
            originView.tabBarController?.tabBar.addSubview(backgroundView)
        } else {
            originView.view.addSubview(backgroundView)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(47)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(72)
        }
        title.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        // MARK: Animation
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.backgroundView.transform = CGAffineTransform(translationX: 0, y: -81)
            } completion: { finished in
                UIView.animate(withDuration: 0.5, delay: 2.5) {
                    self.backgroundView.transform = CGAffineTransform(translationX: 0, y: 81)
                } completion: { finish in
                    if originView.extensionContext != nil {
                        originView.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                    }
                }
            }
        }
    }
}
