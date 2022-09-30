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
    var navigationTitle = UILabel().then{
        $0.text = "목걸이"
        $0.font = UIFont.Suit(size: 15, family: .Bold)
    }
    let backBtn = UIButton().then{
        $0.setImage(UIImage(named: "goBack"), for: .normal)
    }
    let emptyMessage = "앗, 아이템이 없어요!\n갖고 싶은 아이템을 등록해보세요!"
    // MARK: - Life Cycles
    var folderName: String!
    var folderId: Int!
    var folderDetailCollectionView: UICollectionView!
    var wishListData: [WishListModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        if let folderName = self.folderName {navigationTitle.text = folderName}
        
        setUpCollectionView()
        setUpView()
        setUpConstraint()

        self.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        // DATA
        FolderDataManager().getFolderDetailDataManager(self.folderId, self)
    }
    override func viewDidAppear(_ animated: Bool) {
        // DATA
        FolderDataManager().getFolderDetailDataManager(self.folderId, self)
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
        EmptyView().setEmptyView(self.emptyMessage, self.folderDetailCollectionView, count)
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
        let itemIdx = indexPath.item
        let itemDetailVC = ItemDetailViewController()
        itemDetailVC.wishListData = self.wishListData[itemIdx]
        itemDetailVC.modalPresentationStyle = .fullScreen
        self.present(itemDetailVC, animated: true, completion: nil)
    }
}
// MARK: - API Success
extension FolderDetailViewController {
    // 폴더 내 아이템 조회 API
    func getFolderDetailAPISuccess(_ result: [WishListModel]) {
        self.wishListData = result
        // reload data with animation
        UIView.transition(with: folderDetailCollectionView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                              self.folderDetailCollectionView.reloadData()},
                          completion: nil);
    }
    func getFolderDetailAPIFail() {
        FolderDataManager().getFolderDetailDataManager(self.folderId, self)
    }
    func noWishList() {
        self.wishListData = []
        // reload data with animation
        UIView.transition(with: folderDetailCollectionView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                              self.folderDetailCollectionView.reloadData()},
                          completion: nil);
    }
}
