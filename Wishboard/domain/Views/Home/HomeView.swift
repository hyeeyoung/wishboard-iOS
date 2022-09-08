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
    var collectionView : UICollectionView!
    var wishListData: [WishListModel] = []
    
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
            make.top.equalToSuperview().offset(50)
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
}
// MARK: - WishList CollectionView delegate
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = wishListData.count ?? 0
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishListCollectionViewCell.identifier,
                                                            for: indexPath)
                as? WishListCollectionViewCell else{ fatalError() }
        let itemIdx = indexPath.item
        cell.setUpData(self.wishListData[itemIdx])
        return cell
    }
}
// 임시 데이터
extension HomeView {
    func setTempData() {
        self.wishListData.append(WishListModel(itemImage: "", itemName: "item1", itemPrice: 1000, isCart: true))
        self.wishListData.append(WishListModel(itemImage: "", itemName: "item2", itemPrice: 2000, isCart: false))
        self.wishListData.append(WishListModel(itemImage: "", itemName: "item3", itemPrice: 3000, isCart: false))
        self.wishListData.append(WishListModel(itemImage: "", itemName: "item4", itemPrice: 4000, isCart: true))
        self.wishListData.append(WishListModel(itemImage: "", itemName: "item5", itemPrice: 5000, isCart: true))
    }
}
