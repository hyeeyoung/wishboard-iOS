//
//  HomeViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class HomeViewController: UIViewController {
    var homeView: HomeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setToken() 

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.tabBarController?.tabBar.isHidden = false
        
        homeView = HomeView()
        self.view.addSubview(homeView)
        homeView.setViewController(self)
        
        homeView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        // 첫 로그인일 시 앱 이용방법 호출
        let isFirstLogin = UserDefaults.standard.bool(forKey: "isFirstLogin")
        if isFirstLogin {homeView.showBottomSheet(self)}
        
        self.homeView.cartButton.addTarget(self, action: #selector(goToCart), for: .touchUpInside)
        self.homeView.calenderButton.addTarget(self, action: #selector(goCalenderDidTap), for: .touchUpInside)
        // DATA
        WishListDataManager().wishListDataManager(self.homeView, self)
        sendFCM()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        // DATA
        WishListDataManager().wishListDataManager(self.homeView, self)
    }
    // MARK: - Actions & Functions
    @objc func goToCart() {
        let cartVC = CartViewController()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    @objc func goCalenderDidTap() {
        let calenderVC = CalenderViewController()
        self.navigationController?.pushViewController(calenderVC, animated: true)
    }
    func alertDialog() {
        let dialog = PopUpViewController(titleText: "알림 허용", messageText: "알림을 받아보시겠어요?\n직접 등록하신 아이템의 재입고 날짜 등의 상품 일정 알림을 받으실 거에요.", greenBtnText: "나중에", blackBtnText: "허용")
        dialog.modalPresentationStyle = .overCurrentContext
        self.present(dialog, animated: false, completion: nil)
        
        dialog.okBtn.addTarget(self, action: #selector(okButtonDidTap), for: .touchUpInside)
        dialog.cancelBtn.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    @objc func cancelButtonDidTap() {
        // 앱 이용방법 더는 안 띄우게
        UserDefaults.standard.set(false, forKey: "isFirstLogin")
        MypageDataManager().switchNotificationDataManager(false, self)
    }
    @objc func okButtonDidTap() {
        // 앱 이용방법 더는 안 띄우게
        UserDefaults.standard.set(false, forKey: "isFirstLogin")
        MypageDataManager().switchNotificationDataManager(true, self)
    }
}
// MARK: - API Success
extension HomeViewController {
    // MARK: 알림 허용 팝업창
    func switchNotificationAPISuccess(_ result: APIModel<ResultModel>) {
        self.dismiss(animated: false)
        print(result.message)
    }
    func wishListAPIFail() {
        WishListDataManager().wishListDataManager(self.homeView, self)
    }
    // MARK: 카트 추가 API
    func addCartAPISuccess(_ result: APIModel<ResultModel>) {
        WishListDataManager().wishListDataManager(self.homeView, self)
        print(result.message)
    }
    // MARK: FCM API
    func fcmAPISuccess(_ result: APIModel<ResultModel>) {
        print(result.message)
    }
}
// MARK: - Token User Defaults for Share Extension
extension HomeViewController {
    func setToken() {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let defaults = UserDefaults(suiteName: "group.gomin.Wishboard.Share")
        defaults?.set(token, forKey: "token")
        defaults?.synchronize()
    }
    func sendFCM() {
        // Send FCM token to server
        let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? ""
        let fcmInput = FCMInput(fcm_token: deviceToken)
        FCMDataManager().fcmDataManager(fcmInput, self)
    }
}
