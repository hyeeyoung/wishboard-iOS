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
    let navigationView = UIView()
    let logo = UIImageView().then{
        $0.image = UIImage(named: "WishBoardLogo")
    }
    let cartButton = UIButton().then{
        $0.setImage(UIImage(named: "cart"), for: .normal)
    }
    
    // MARK: - Life Cycles
    var viewController : HomeViewController!
    var collectionView : UICollectionView!
    var wishListData: [WishListModel] = []
    let emptyMessage = "앗, 아이템이 없어요!\n갖고 싶은 아이템을 등록해보세요!"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCollectionView()
        setUpView()
        setUpConstraint()
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
        addSubview(navigationView)
        
        navigationView.addSubview(logo)
        navigationView.addSubview(cartButton)

        addSubview(collectionView)
    }
    func setUpNavigationConstraint() {
        navigationView.snp.makeConstraints { make in
            if CheckNotch().hasNotch() {make.top.equalToSuperview().offset(50)}
            else {make.top.equalToSuperview().offset(20)}
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        logo.snp.makeConstraints { make in
            make.width.equalTo(145)
            make.height.equalTo(19)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        cartButton.snp.makeConstraints { make in
            make.width.equalTo(23)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
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
        
        let addCartGesture = AddCartGesture(target: self, action: #selector(addCartButtonDidTap(_:)))
        addCartGesture.itemId = self.wishListData[itemIdx].item_id
        cell.cartButton.addGestureRecognizer(addCartGesture)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemIdx = indexPath.item
        
        let itemDetailVC = ItemDetailViewController()
        itemDetailVC.wishListData = self.wishListData[itemIdx]
        itemDetailVC.modalPresentationStyle = .fullScreen
        self.viewController.present(itemDetailVC, animated: true, completion: nil)
    }
}
extension HomeView {
    @objc func addCartButtonDidTap(_ sender: AddCartGesture) {
        if let itemId = sender.itemId {
            let addCartInput = AddCartInput(item_id: itemId)
            CartDataManager().addCartDataManager(addCartInput, self, self.viewController)
        }
    }
}
// MARK: - API Success
extension HomeView {
    // MARK: 위시리스트 조회 API
    func wishListAPISuccess(_ result: [WishListModel]) {
        self.wishListData = result
        print(result)
        // reload data with animation
        UIView.transition(with: collectionView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { () -> Void in
                                    self.collectionView.reloadData()},
                                completion: nil);
    }
}
// MARK: - CartGesture
class AddCartGesture: UITapGestureRecognizer {
    var itemId: Int?
}
