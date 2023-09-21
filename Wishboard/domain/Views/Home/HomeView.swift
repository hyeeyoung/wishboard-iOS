//
//  HomeView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import Foundation
import UIKit
import SnapKit
import Then
import MaterialComponents.MaterialBottomSheet

class HomeView: UIView {
    // MARK: - Properties
    // Navigation Views
    
    /// 이벤트뷰와 네비게이션 뷰가 있는 Stack
    let navigationViewStack = UIStackView().then {
        $0.axis = .vertical
    }
    let eventView = UIView().then {
        $0.backgroundColor = .gray_700
        $0.isUserInteractionEnabled = true
        $0.isHidden = true
    }
    let eventLabel = UILabel().then {
        $0.text = "위시보드 설문조사 참여하고 기프티콘 받으세요! 🤍 "
        $0.textColor = .white
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD2)
    }
    let eventQuitButton = UIButton().then {
        $0.setImage(Image.whiteQuit, for: .normal)
    }
    let navigationView = UIView()
    
    let logo = UIImageView().then{
        $0.image = Image.wishboardLogo
    }
    let cartButton = UIButton().then{
        $0.setImage(Image.cartIcon, for: .normal)
    }
    let calenderButton = UIButton().then{
        $0.setImage(Image.calender, for: .normal)
    }
    
    // MARK: - Life Cycles
    var viewController : HomeViewController!
    var collectionView : UICollectionView!
    var wishListData: [WishListModel] = []
    let emptyMessage = "앗, 아이템이 없어요!\n갖고 싶은 아이템을 등록해보세요!"
    var refreshControl = UIRefreshControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCollectionView()
        setUpView()
        setUpConstraint()
        
        initRefresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setViewController(_ viewcontroller: HomeViewController) {
        self.viewController = viewcontroller
    }
    func setCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()) .then{
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            

            var bounds = UIScreen.main.bounds
            var width = bounds.size.width / 2
            
            flowLayout.itemSize = CGSize(width: width, height: 260)
            flowLayout.scrollDirection = .vertical
            
            $0.collectionViewLayout = flowLayout
            $0.dataSource = self
            $0.delegate = self
            $0.showsVerticalScrollIndicator = false
            
            $0.register(WishListCollectionViewCell.self, forCellWithReuseIdentifier: WishListCollectionViewCell.identifier)
        }
    }
    func setUpView() {
        addSubview(navigationViewStack)
        navigationViewStack.addArrangedSubview(eventView)
        navigationViewStack.addArrangedSubview(navigationView)
        
        eventView.addSubview(eventLabel)
        eventView.addSubview(eventQuitButton)
        
        navigationView.addSubview(logo)
        navigationView.addSubview(calenderButton)
        navigationView.addSubview(cartButton)

        addSubview(collectionView)
    }
    func setUpNavigationConstraint() {
        navigationViewStack.snp.makeConstraints { make in
            if UIDevice.current.hasNotch {make.top.equalToSuperview().offset(50)}
            else {make.top.equalToSuperview().offset(20)}
            make.leading.trailing.equalToSuperview()
        }
        eventView.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        eventQuitButton.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.trailing.equalToSuperview().offset(-13)
            make.centerY.equalToSuperview()
        }
        eventLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(eventQuitButton.snp.leading).offset(-16)
        }
        navigationView.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        logo.snp.makeConstraints { make in
            make.width.equalTo(136.13)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        calenderButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        cartButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(calenderButton.snp.leading).offset(-16)
        }
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }
    }
    // Bottom Sheet
    func showBottomSheet(_ preVC: HomeViewController) {
        let vc = HowToViewController()
        vc.preVC = preVC
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: vc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 610
        bottomSheet.dismissOnDraggingDownSheet = false
        
        self.viewController.present(bottomSheet, animated: true, completion: nil)
    }
}
// MARK: - WishList CollectionView delegate
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = wishListData.count ?? 0
        EmptyView().setEmptyView(self.emptyMessage, self.collectionView, count)
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
        self.viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HomeView {
    // 장바구니 추가, 삭제
    @objc func cartButtonDidTap(_ sender: HomeCartGesture) {
        UIDevice.vibrate()
        if let data = sender.data {
            if data.cart_state == 1 {
                CartDataManager().deleteCartDataManager(data.item_id!, self.viewController)
            } else {
                let addCartInput = AddCartInput(item_id: data.item_id)
                CartDataManager().addCartDataManager(addCartInput, self.viewController)
            }
        }
    }
}
// MARK: - API Success
extension HomeView {
    // MARK: 위시리스트 조회 API
    func wishListAPISuccess(_ result: [WishListModel]) {
        self.wishListData = result
        // reload data with animation
        UIView.transition(with: collectionView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { () -> Void in
                                    self.collectionView.reloadData()},
                                completion: nil);
        refreshControl.endRefreshing()
    }
}
// MARK: - Refresh
extension HomeView {
    func initRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .gray_700
        
        collectionView.refreshControl = refreshControl
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // DATA reload
            WishListDataManager().wishListDataManager(self, self.viewController)
            self.collectionView.reloadData()
            refresh.endRefreshing()
        }
    }
}
// MARK: - CartGesture
class HomeCartGesture: UITapGestureRecognizer {
    var data: WishListModel?
}
