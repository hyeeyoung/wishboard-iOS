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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.tabBarController?.tabBar.isHidden = true
        
        let view = OnBoardingView()
        view.setViewController(self)
        self.view.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        checkRememberMe()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
        // 자동 로그인
        checkRememberMe()
    }
    func checkRememberMe() {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let email = UserDefaults.standard.string(forKey: "email")
            let password = UserDefaults.standard.string(forKey: "password")
            print(email, password, token)
            
            // FCM
            sendFCM()
            // go Main
            ScreenManager().goMain(self)
        }
    }
    // MARK: FCM API
    func sendFCM() {
        // Send FCM token to server
        let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? ""
        print("device Token:", deviceToken)
        let fcmInput = FCMInput(fcm_token: deviceToken)
        FCMDataManager().fcmDataManager(fcmInput, self)
    }
    func fcmAPISuccess(_ result: APIModel<ResultModel>) {
        print("FCMAPI::", result.message)
    }
}
