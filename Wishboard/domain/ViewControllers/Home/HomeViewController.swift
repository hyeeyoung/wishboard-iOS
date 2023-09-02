//
//  HomeViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class HomeViewController: UIViewController, Observer {
    var homeView: HomeView!
    var observer = WishListObserver.shared

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
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        homeView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-tabBarHeight)
        }
        
        // 첫 로그인일 시 앱 이용방법 호출
        let isFirstLogin = UserManager.isFirstLogin ?? true
        if isFirstLogin {homeView.showBottomSheet(self)}
        
        self.homeView.cartButton.addTarget(self, action: #selector(goToCart), for: .touchUpInside)
        self.homeView.calenderButton.addTarget(self, action: #selector(goCalenderDidTap), for: .touchUpInside)
        
        observer.bind(self)
        
        // DATA
        WishListDataManager().wishListDataManager(self.homeView, self)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    func update(_ newValue: Any) {
        if let usecase = newValue as? WishListUseCase, usecase == .delete {
            SnackBar(self, message: .deleteItem)
            WishListDataManager().wishListDataManager(self.homeView, self)
        }
    }
    // MARK: - Actions & Functions
    @objc func goToCart() {
        UIDevice.vibrate()
        let cartVC = CartViewController()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    @objc func goCalenderDidTap() {
        let calenderVC = CalenderViewController()
        self.navigationController?.pushViewController(calenderVC, animated: true)
        UIDevice.vibrate()
    }
    func alertDialog() {
        let model = PopUpModel(title: "알림 허용",
                               message: "알림을 받아보시겠어요?\n직접 등록하신 아이템의 재입고 날짜 등의\n상품 일정 알림을 받으실 거에요.",
                               greenBtnText: "나중에",
                               blackBtnText: "허용")
        let dialog = PopUpViewController(model)
        self.present(dialog, animated: false, completion: nil)
        
        dialog.okBtn.addTarget(self, action: #selector(okButtonDidTap), for: .touchUpInside)
        dialog.cancelBtn.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    @objc func cancelButtonDidTap() {
        // 앱 이용방법 더는 안 띄우게
        UserManager.isFirstLogin = false
        MypageDataManager().switchNotificationDataManager(false, self)
        UIDevice.vibrate()
    }
    @objc func okButtonDidTap() {
        // 앱 이용방법 더는 안 띄우게
        UserManager.isFirstLogin = false
        MypageDataManager().switchNotificationDataManager(true, self)
        UIDevice.vibrate()
    }
}
// MARK: - API Success
extension HomeViewController {
    // MARK: 알림 허용 팝업창
    func switchNotificationAPISuccess(_ result: APIModel<TokenResultModel>) {
        self.dismiss(animated: false)
        print(result.message)
    }
    func wishListAPIFail() {
        WishListDataManager().wishListDataManager(self.homeView, self)
    }
    // MARK: 카트 추가 API
    func addCartAPISuccess(_ result: APIModel<TokenResultModel>) {
        WishListDataManager().wishListDataManager(self.homeView, self)
        print(result.message)
    }
    // MARK: 장바구니 삭제 API
    func deleteCartAPISuccess(_ result: APIModel<TokenResultModel>) {
        WishListDataManager().wishListDataManager(self.homeView, self)
        print(result.message)
    }
}
// MARK: - Token User Defaults for Share Extension
extension HomeViewController {
    func setToken() {
        let accessToken = UserManager.accessToken
        let refreshToken = UserManager.refreshToken
        
        let defaults = UserDefaults(suiteName: "group.gomin.Wishboard.Share")
        defaults?.set(accessToken, forKey: "accessToken")
        defaults?.set(refreshToken, forKey: "refreshToken")
        defaults?.synchronize()
    }
}
