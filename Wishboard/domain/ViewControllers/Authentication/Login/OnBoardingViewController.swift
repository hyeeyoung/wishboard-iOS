//
//  OnBoardingViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/05.
//

import UIKit

class OnBoardingViewController: UIViewController {
    var deleteUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // 점검 이슈 알럿창
//        view.backgroundColor = .white
//        showServiceInspectionAlert()
        
        setLayout()
        checkRememberMe()
    }
    override func viewDidAppear(_ animated: Bool) {
//        // 점검 이슈 알럿창
//        showServiceInspectionAlert()
//
        self.tabBarController?.tabBar.isHidden = true
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
        // 자동 로그인
        checkRememberMe()
        // 탈퇴 후 스낵바
        if self.deleteUser {
            SnackBar(self, message: .deleteUser)
            self.deleteUser.toggle()
        }
    }
    func checkRememberMe() {
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            let email = UserDefaults.standard.string(forKey: "email")
            let password = UserDefaults.standard.string(forKey: "password")
            print(email, password, token)
            
            // go Main
            ScreenManager().goMain(self)
        }
    }
}
extension OnBoardingViewController {
    private func setLayout() {
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
    }
    
//    private func showServiceInspectionAlert() {
//        let dialog = PopUpViewController(titleText: "서비스 일시 중단 안내", messageText: " 서버 이전으로 서비스가\n일시 중단되오니 양해 부탁드립니다.\n보다 안정적인 위시보드로 곧 돌아올게요!\n자세한 사항은 공지사항을 확인해 주세요 😉", greenBtnText: "공지사항 확인", blackBtnText: "앱 종료")
//        dialog.modalPresentationStyle = .overFullScreen
//        self.present(dialog, animated: false, completion: nil)
//
//        dialog.cancelBtn.addTarget(self, action: #selector(appNoticeButtonDidTap), for: .touchUpInside)
//        dialog.okBtn.addTarget(self, action: #selector(quitButtonDidTap), for: .touchUpInside)
//    }
//    @objc func appNoticeButtonDidTap() {
//        ScreenManager().linkTo(viewcontroller: self, "https://www.instagram.com/p/CtN6KfUPqbI/?igshid=NTc4MTIwNjQ2YQ==")
//    }
//    @objc func quitButtonDidTap() {
//        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            exit(0)
//        }
//    }
    
}
