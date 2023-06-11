//
//  FolderDetailViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/21.
//

import UIKit

class FolderDetailViewController: TitleCenterViewController {
    // MARK: - View
    let emptyMessage = EmptyMessage.item
    // MARK: - Life Cycles
    var folderName: String!
    var folderId: Int!
    var folderDetailCollectionView: UICollectionView!
    var wishListData: [WishListModel] = []
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        setUpView()
        initRefresh()

        // DATA
        if let folderName = self.folderName {super.navigationTitle.text = folderName}
        if let folderId = self.folderId {
            FolderDataManager().getFolderDetailDataManager(self.folderId, self)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        // DATA
        if let folderName = self.folderName {super.navigationTitle.text = folderName}
        if let folderId = self.folderId {
            FolderDataManager().getFolderDetailDataManager(self.folderId, self)
        }
    }
}
// MARK: - Actions & Functions
extension FolderDetailViewController {
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
        self.view.addSubview(folderDetailCollectionView)
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        folderDetailCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
            make.bottom.equalToSuperview().offset(-tabBarHeight)
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
        
        let cartGesture = HomeCartGesture(target: self, action: #selector(cartButtonDidTap(_:)))
        cartGesture.data = self.wishListData[itemIdx]
        cell.cartButton.addGestureRecognizer(cartGesture)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIDevice.vibrate()
        
        let itemIdx = indexPath.item
        let itemDetailVC = ItemDetailViewController()
        itemDetailVC.preVC = self
        itemDetailVC.itemId = self.wishListData[itemIdx].item_id
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }
}
extension FolderDetailViewController {
    // MARK: 장바구니 버튼 클릭 이벤트
    @objc func cartButtonDidTap(_ sender: HomeCartGesture) {
        UIDevice.vibrate()
        if let data = sender.data {
            // 장바구니 삭제
            if data.cart_state == 1 {
                CartDataManager().deleteCartDataManager(data.item_id!, self)
            } else {
                // 장바구니 추가
                let addCartInput = AddCartInput(item_id: data.item_id)
                CartDataManager().addCartDataManager(addCartInput, self)
            }
        }
    }
    // MARK: 장바구니 추가 API
    func addCartAPISuccess(_ result: APIModel<TokenResultModel>) {
        if let folderId = self.folderId {
            FolderDataManager().getFolderDetailDataManager(self.folderId, self)
        }
        print(result.message)
    }
    // MARK: 장바구니 삭제 API
    func deleteCartAPISuccess(_ result: APIModel<TokenResultModel>) {
        if let folderId = self.folderId {
            FolderDataManager().getFolderDetailDataManager(self.folderId, self)
        }
        print(result.message)
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
        refreshControl.endRefreshing()
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
extension FolderDetailViewController {
    func initRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .gray_700
        
        folderDetailCollectionView.refreshControl = refreshControl
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // DATA reload
            FolderDataManager().getFolderDetailDataManager(self.folderId, self)
            self.folderDetailCollectionView.reloadData()
            refresh.endRefreshing()
        }
    }
}
