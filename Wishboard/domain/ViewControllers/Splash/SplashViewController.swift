//
//  SplashViewController.swift
//  Wishboard
//
//  Created by gomin on 2023/12/24.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        setupUI()

        // 2초 후에 메인 화면으로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let navigationController = UINavigationController(rootViewController: OnBoardingViewController())
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(navigationController, animated: true)
        }
    }

    private func setupUI() {
        let logo = UIImageView().then {
            $0.image = Image.wishboardLogo
        }
        
        self.view.addSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.width.equalTo(263)
            make.height.equalTo(32)
            make.center.equalToSuperview()
        }
        
        #if DEBUG
        self.setUpVersionLabel("dev")
        
//        #elseif REL
//        self.setUpVersionLabel("rel")

        #endif
        
    }
    
    private func setUpVersionLabel(_ version: String) {
        let debugVersion = UILabel().then {
            $0.text = "Version: \(Bundle.appVersion)(\(version))\nBuildVersion: \(Bundle.appBuildVersion)\nServer: \(Storage().BaseURL)"
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 10)
            $0.textColor = .gray_700
        }
        
        self.view.addSubview(debugVersion)
        
        debugVersion.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(50)
        }
    }

}
