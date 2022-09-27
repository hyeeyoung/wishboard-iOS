//
//  FolderDetailViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/21.
//

import UIKit

class FolderDetailViewController: UIViewController {
    // MARK: - View
    let navigationView = UIView()
    let navigationTitle = UILabel().then{
        $0.text = "목걸이"
        $0.font = UIFont.Suit(size: 15, family: .Bold)
    }
    let backBtn = UIButton().then{
        $0.setImage(UIImage(named: "goBack"), for: .normal)
    }

    // MARK: - Life Cycles
    var folderDetailCollectionView: UICollectionView!
    var wishListData: [WishListModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        setUpCollectionView()
        setUpView()
        setUpConstraint()

        setTempData()
        self.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
}
// MARK: - Actions & Functions
extension FolderDetailViewController {
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    func setUpCollectionView() {
        folderDetailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
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
        self.view.addSubview(navigationView)
        navigationView.addSubview(navigationTitle)
        navigationView.addSubview(backBtn)
        
        self.view.addSubview(folderDetailCollectionView)
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        
        folderDetailCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.navigationView.snp.bottom)
        }
    }
    func setUpNavigationConstraint() {
        navigationView.snp.makeConstraints{ make in
            if CheckNotch().hasNotch() {make.top.equalToSuperview().offset(50)}
            else {make.top.equalToSuperview().offset(20)}
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        backBtn.snp.makeConstraints{ make in
            make.width.height.equalTo(24)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        navigationTitle.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
// MARK: - CollectionView delegate
extension FolderDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemDetailVC = ItemDetailViewController()
        itemDetailVC.modalPresentationStyle = .fullScreen
        self.present(itemDetailVC, animated: true, completion: nil)
    }
    
    func setTempData() {
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item1", itemPrice: 1000, isCart: true))
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item2", itemPrice: 2000, isCart: false))
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item3", itemPrice: 3000, isCart: false))
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item4", itemPrice: 4000, isCart: true))
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item5", itemPrice: 5000, isCart: true))
    }
}
