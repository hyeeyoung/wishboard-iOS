//
//  HomeViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit
import MaterialComponents.MaterialBottomSheet
import RxSwift

class HomeViewController: UIViewController, Observer {
    var homeView: HomeView!
    var observer = WishItemObserver.shared
    
    // Properties
    var wishListData: [WishListModel] = []
    let emptyMessage = "앗, 아이템이 없어요!\n갖고 싶은 아이템을 등록해보세요!"
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setToken()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.tabBarController?.tabBar.isHidden = false
        
        homeView = HomeView()
        self.view.addSubview(homeView)
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        homeView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-tabBarHeight)
        }
        homeView.collectionView.dataSource = self
        homeView.collectionView.delegate = self
        
        // 첫 로그인일 시 앱 이용방법 호출
        let isFirstLogin = UserManager.isFirstLogin ?? true
        if isFirstLogin {showBottomSheet()}
        
        self.homeView.cartButton.addTarget(self, action: #selector(goToCart), for: .touchUpInside)
        self.homeView.calenderButton.addTarget(self, action: #selector(goCalenderDidTap), for: .touchUpInside)
        
        observer.bind(self)
        
        // DATA
        WishListDataManager.shared.wishListDataManager(self)
        // Init RefreshControl
        initRefresh()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
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
            WishListDataManager.shared.wishListDataManager(self)
        }
    }
    // Bottom Sheet
    func showBottomSheet() {
        let vc = HowToViewController()
        vc.preVC = self
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: vc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 610
        bottomSheet.dismissOnDraggingDownSheet = false
        
        present(bottomSheet, animated: true, completion: nil)
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
// MARK: - WishList CollectionView delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = wishListData.count
        EmptyView().setEmptyView(self.emptyMessage, homeView.collectionView, count)
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishListCollectionViewCell.identifier,
                                                            for: indexPath)
                as? WishListCollectionViewCell else{ fatalError() }
        let itemIdx = indexPath.item
        cell.setUpData(self.wishListData[itemIdx])
        
        let cartGesture = HomeCartGesture(target: self, action: #selector(cartButtonDidTap(_:)))
        cartGesture.data = self.wishListData[itemIdx]
        cell.cartButton.addGestureRecognizer(cartGesture)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIDevice.vibrate()
        
        let itemIdx = indexPath.item
        let vc = ItemDetailViewController()
        vc.itemId = self.wishListData[itemIdx].item_id
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - Cart
extension HomeViewController {
    // 장바구니 추가, 삭제
    @objc func cartButtonDidTap(_ sender: HomeCartGesture) {
        sender.isEnabled = false
        UIDevice.vibrate()
        
        if let data = sender.data {
            if data.cart_state == 1 {
                CartDataManager().deleteCartDataManager(data.item_id!, self)
            } else {
                let addCartInput = AddCartInput(item_id: data.item_id)
                CartDataManager().addCartDataManager(addCartInput, self)
            }
        }
        // 지정된 시간 후에 버튼 다시 활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            sender.isEnabled = true
        }
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
            // DATA reload
            WishListDataManager.shared.wishListDataManager(self)
            refresh.endRefreshing()
        }
    }
}
// MARK: - API
extension HomeViewController {
    /// 위시리스트 조회 API 성공
    func wishListAPISuccess(_ result: [WishListModel]) {
        self.wishListData = result
        // 애니메이션과 함께 reload
        self.reloadWithAnimation()
        refreshControl.endRefreshing()
    }
    /// 알림 허용 팝업창
    func switchNotificationAPISuccess(_ result: APIModel<TokenResultModel>) {
        self.dismiss(animated: false)
        print(result.message)
    }
    /// 위시리스트 조회 실패
    func wishListAPIFail() {
        WishListDataManager.shared.wishListDataManager(self)
    }
    /// 카트 추가 API
    func addCartAPISuccess(_ result: APIModel<TokenResultModel>) {
        WishListDataManager.shared.wishListDataManager(self)
        print(result.message)
    }
    /// 장바구니 삭제 API
    func deleteCartAPISuccess(_ result: APIModel<TokenResultModel>) {
        WishListDataManager.shared.wishListDataManager(self)
        print(result.message)
    }
    
    func reloadWithAnimation() {
        UIView.transition(with: homeView.collectionView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { () -> Void in
                                    self.homeView.collectionView.reloadData()},
                                    completion: nil);
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
