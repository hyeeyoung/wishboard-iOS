//
//  HomeViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit
import MaterialComponents.MaterialBottomSheet
import RxCocoa
import RxSwift

class HomeViewController: UIViewController, Observer {
    var homeView: HomeView!
    var viewModel = HomeViewModel()
    var disposeBag = DisposeBag()
    
    var observer = WishItemObserver.shared
    
    // 이벤트뷰 관련 Properties
    let koreanTimeZone = TimeZone(identifier: "Asia/Seoul")!
    let koreanCalendar = Calendar(identifier: .gregorian)
    
    // Properties
    let emptyMessage = "앗, 아이템이 없어요!\n갖고 싶은 아이템을 등록해보세요!"
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setTapEvent()
        
        // Init RefreshControl
        initRefresh()
        
        // Bind
        observer.bind(self)
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
        // 이벤트뷰
        performEventView()
    }
    
    func bind() {
        let input = HomeViewModel.Input(cartButtonTap: PublishSubject<(cartState: Int, itemId: Int)>())
        let output = viewModel.transform(input)
        
        // 위시리스트 조회 성공 시 데이터를 처리
        output.wishListSuccessResponse
            .subscribe(onNext: { [weak self] wishList in
                self?.reloadWishListCollectionView()
            })
            .disposed(by: disposeBag)
        
        // 위시리스트 조회 실패 시 에러 코드 처리
        output.wishListFailCode
            .subscribe(onNext: { errorCode in
                print("위시리스트 조회: \(errorCode) Error")
            })
            .disposed(by: disposeBag)
        
        // 위시리스트 조회 성공 시 CollectionView Reload
        viewModel.reloadCollectionView
            .subscribe(onNext: { [weak self] wishList in
                self?.reloadWishListCollectionView()
            })
            .disposed(by: disposeBag)
        
        // 회원가입 후 첫 로그인일 시 앱 이용방법 호출
        viewModel.performAppGuide
            .subscribe(onNext: { [weak self] wishList in
                self?.showAppGuideBottomSheet()
            })
            .disposed(by: disposeBag)
        
    }
    
    func update(_ newValue: Any) {
        // 케이스에 따른 스낵바 출력
        if let usecase = newValue as? WishItemUseCase {
            if usecase == .delete {
                SnackBar.shared.showSnackBar(tabBarController ?? self, message: .deleteItem)
            } else if usecase == .upload {
                SnackBar.shared.showSnackBar(tabBarController ?? self, message: .addItem)
            }
            // Data reload
            viewModel.refreshWishList()
                .subscribe(onNext: { [weak self] wishList in
                    self?.reloadWishListCollectionView()
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    /// 버튼 이벤트 정의
    func setTapEvent() {
        homeView.cartButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.goToCart()
            })
            .disposed(by: disposeBag)
        
        homeView.calenderButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.goCalenderDidTap()
            })
            .disposed(by: disposeBag)
        
        // 이벤트뷰 관련 메서드 (temporary)
        let eventTapGesture = UITapGestureRecognizer()
        homeView.eventView.addGestureRecognizer(eventTapGesture)
        eventTapGesture.rx.event
            .subscribe(onNext: { [weak self] gesture in
                if gesture.state == .ended {
                    self?.goToEvent()
                }
            })
            .disposed(by: disposeBag)
        
        homeView.eventQuitButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.closeEventTab()
            })
            .disposed(by: disposeBag)
        
    }
    
    /// View 관련 정의
    func setView() {
        // TabViewController, NavigationViewController 관련 정의
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.tabBarController?.tabBar.isHidden = false
        
        // HomeView 관련 정의
        homeView = HomeView()
        self.view.addSubview(homeView)
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        homeView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-tabBarHeight)
        }
        homeView.collectionView.dataSource = self
        homeView.collectionView.delegate = self
    }
    
    /// 앱 이용방법 바텀시트 보여주기
    func showAppGuideBottomSheet() {
        let vc = HowToViewController()
        vc.preVC = self
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: vc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 610
        bottomSheet.dismissOnDraggingDownSheet = false
        
        present(bottomSheet, animated: true, completion: nil)
    }
    // MARK: - Actions & Functions
    /// 장바구니 이동
    func goToCart() {
        UIDevice.vibrate()
        let cartVC = CartViewController()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    /// 달력 알람 이동
    func goCalenderDidTap() {
        let calenderVC = CalenderViewController()
        self.navigationController?.pushViewController(calenderVC, animated: true)
        UIDevice.vibrate()
    }
    /// 회원가입 후 앱 첫 진입 시 알림허용 팝업창
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
        UIDevice.vibrate()
        // 앱 이용방법 더는 안 띄우게
        UserManager.isFirstLogin = false
        MypageDataManager().switchNotificationDataManager(false, self)
    }
    @objc func okButtonDidTap() {
        UIDevice.vibrate()
        // 앱 이용방법 더는 안 띄우게
        UserManager.isFirstLogin = false
        MypageDataManager().switchNotificationDataManager(true, self)
    }
}
// MARK: - WishList CollectionView delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.wishList.count
        EmptyView().setEmptyView(self.emptyMessage, homeView.collectionView, count)
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishListCollectionViewCell.identifier,
                                                            for: indexPath)
                as? WishListCollectionViewCell else{ fatalError() }
        
        setWishItem(cell, collectionView, indexPath)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIDevice.vibrate()
        
        let itemIdx = indexPath.item
        let vc = ItemDetailViewController()
        vc.itemId = viewModel.wishList[itemIdx].item_id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 위시아이템의 UI 설정 및 장바구니 버튼 탭 이벤트 관리
    func setWishItem(_ cell: WishListCollectionViewCell, _ collectionView: UICollectionView, _ indexPath: IndexPath) {
        cell.setUpData(viewModel.wishList[indexPath.item])
        
        cell.cartButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let indexPath = collectionView.indexPath(for: cell) {
                    let itemIdx = indexPath.item
                    let itemData = self?.viewModel.wishList[itemIdx]
                    
                    print("💗", itemData?.item_id)
                    
                    let cartState = itemData?.cart_state ?? 0
                    let itemId = itemData?.item_id ?? -1
                    let buttonTapData = (cartState: cartState, itemId: itemId)
                    
                    self?.viewModel.input.cartButtonTap.onNext(buttonTapData)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Event
/// 이벤트 관련 메서드 처리
extension HomeViewController {
    /// 이벤트 탭 클릭
    func goToEvent() {
        let eventLink = "https://docs.google.com/forms/d/e/1FAIpQLSenh6xOvlDa61iw1UKBSM6SixdrgF17_i91Brb2osZcxB7MOQ/viewform?usp=sharing"
        ScreenManager.shared.linkTo(viewcontroller: self, eventLink)
    }
    /// 이벤트 탭 지우기 버튼
    func closeEventTab() {
        // x버튼을 클릭한 시간을 저장 - 24시간 후 재출력
        let currentTime = Date()
        UserDefaults.standard.set(currentTime, forKey: "lastEventViewCloseTime")
        
        hideEventView()
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
}

// MARK: - Refresh
extension HomeViewController {
    func initRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .gray_700
        
        homeView.collectionView.refreshControl = refreshControl
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel.refreshWishList()
                .subscribe(onNext: { [weak self] wishList in
                    self?.reloadWishListCollectionView()
                })
                .disposed(by: self.disposeBag)
            
            refresh.endRefreshing()
        }
    }
}
// MARK: - API
extension HomeViewController {
    /// 애니메이션과 함께 reload
    func reloadWishListCollectionView() {
        UIView.transition(with: homeView.collectionView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { () -> Void in
                                    self.homeView.collectionView.reloadData()},
                                completion: nil);
        refreshControl.endRefreshing()
    }
    /// 알림 허용 팝업창
    func switchNotificationAPISuccess(_ result: APIModel<TokenResultModel>) {
        self.dismiss(animated: false)
        print(result.message)
    }
    /// 위시리스트 조회 실패
    func wishListAPIFail() {
//        WishListDataManager.shared.wishListDataManager(self)
    }
}
