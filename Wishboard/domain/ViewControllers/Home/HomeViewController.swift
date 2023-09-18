//
//  HomeViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class HomeViewController: UIViewController, Observer {
    var homeView: HomeView!
    var observer = WishItemObserver.shared
    
    // 이벤트뷰 관련 Properties
    let koreanTimeZone = TimeZone(identifier: "Asia/Seoul")!
    let koreanCalendar = Calendar(identifier: .gregorian)

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
        self.homeView.eventView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToEvent)))
        self.homeView.eventQuitButton.addTarget(self, action: #selector(closeEventTab), for: .touchUpInside)
        
        observer.bind(self)
        
        // DATA
        WishListDataManager().wishListDataManager(self.homeView, self)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
        // 이벤트뷰
        performEventView()
    }
    func update(_ newValue: Any) {
        // 케이스에 따른 스낵바 출력
        if let usecase = newValue as? WishItemUseCase {
            if usecase == .delete {
                SnackBar(tabBarController ?? self, message: .deleteItem)
            } else if usecase == .upload {
                SnackBar(tabBarController ?? self, message: .addItem)
            }
            // Data reload
            WishListDataManager().wishListDataManager(self.homeView, self)
        }
    }
    // MARK: - Actions & Functions
    /// 장바구니 이동
    @objc func goToCart() {
        UIDevice.vibrate()
        let cartVC = CartViewController()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    /// 달력 알람 이동
    @objc func goCalenderDidTap() {
        let calenderVC = CalenderViewController()
        self.navigationController?.pushViewController(calenderVC, animated: true)
        UIDevice.vibrate()
    }
    /// 이벤트 탭 클릭
    @objc func goToEvent() {
        let eventLink = "https://docs.google.com/forms/d/e/1FAIpQLSenh6xOvlDa61iw1UKBSM6SixdrgF17_i91Brb2osZcxB7MOQ/viewform?usp=sharing"
        ScreenManager.shared.linkTo(viewcontroller: self, eventLink)
    }
    /// 이벤트 탭 지우기 버튼
    @objc func closeEventTab() {
        // x버튼을 클릭한 시간을 저장 - 24시간 후 재출력
        let currentTime = Date()
        UserDefaults.standard.set(currentTime, forKey: "lastEventViewCloseTime")
        
        hideEventView()
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
    /// 이벤트뷰 24시간 로직 처리
    func performEventView() {
        // 설문조사 기한 마감
        let eventDate: Date = {
            // 2023년 11월 20일
            var components = DateComponents()
            components.year = 2023
            components.month = 11
            components.day = 20
            components.hour = 0
            components.minute = 0
            components.second = 0
            return koreanCalendar.date(from: components)!
        }()
        
        let currentTime = Date()
        // 한국 시간대를 기준으로 현재 시간과 이벤트 날짜와의 차이를 계산
        let timeDifference = koreanCalendar.dateComponents([.second], from: currentTime, to: eventDate)
        // 현재 시간이 이벤트 날짜 이후라면 이벤트 뷰를 표시하지 않음
        let isOverDeadline = timeDifference.second ?? 0 < 0
        if isOverDeadline {
            hideEventView()
            return
        }
        
        // 앱이 시작될 때 UserDefaults에서 저장된 시간을 가져옴
        if let lastCloseTime = UserDefaults.standard.object(forKey: "lastEventViewCloseTime") as? Date {
            // 현재 시간과 저장된 시간 간의 차이를 계산
            let currentTime = Date()
            let timeInterval = currentTime.timeIntervalSince(lastCloseTime)
            
            // 만약 24시간 이상이 지났다면 이벤트 뷰를 다시 나타냄
            if timeInterval >= 24 * 60 * 60 { // 24시간 = 24 * 60 * 60 초
                self.presentEventView()
            } else {
                self.hideEventView()
            }
        } else {
            // UserDefaults에 저장된 시간이 없을 경우 처음 앱을 실행한 것으로 간주하고 이벤트 뷰를 나타냄
            self.presentEventView()
        }
    }
    /// 이벤트 뷰를 나타내는 메서드
    private func presentEventView() {
        homeView.eventView.isHidden = false
    }
    /// 이벤트 뷰를 숨기는 메서드
    private func hideEventView() {
        homeView.eventView.isHidden = true
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
