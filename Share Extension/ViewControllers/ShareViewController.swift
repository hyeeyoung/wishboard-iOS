//
//  ShareViewController.swift
//  Share Extension
//
//  Created by gomin on 2022/09/25.
//

import UIKit
import Social
import SnapKit
import Then
import MaterialComponents.MaterialBottomSheet
import Lottie

class ShareViewController: UIViewController {
    //MARK: - Properties
    var shareView: ShareView!
    
    var notivc: NotificationSettingViewController!
    var newFoldervc: NewFolderViewController!
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear

//        let defaults = UserDefaults(suiteName: "group.gomin.Wishboard.Share")
//        defaults?.set("sss", forKey: "share")
//        defaults?.synchronize()
        
        setUpShareView()
    }
    //MARK: - Functions
    func setUpShareView() {
        // Set Views & Constraints
        shareView = ShareView()
        self.view.addSubview(shareView)
        shareView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        shareView.setUpCollectionView(dataSourceDelegate: self)
        shareView.setUpView()
        shareView.setUpConstraint()
        // Set BottomSheets
        notivc = NotificationSettingViewController()
        newFoldervc = NewFolderViewController()
        // Add Targets
        shareView.quitButton.addTarget(self, action: #selector(quit), for: .touchUpInside)
        shareView.completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
        shareView.setNotificationButton.addTarget(self, action: #selector(showNotificationBottomSheet), for: .touchUpInside)
        shareView.addFolderButton.addTarget(self, action: #selector(showAddNewFolderBottomSheet), for: .touchUpInside)
    }
    // MARK: - Actions
    @objc func quit() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
    @objc func completeButtonDidTap() {
        let lottieView = shareView.completeButton.setHorizontalLottieView(shareView.completeButton)
        shareView.completeButton.isSelected = true
        lottieView.isHidden = false
        lottieView.loopMode = .repeat(2) // 2번 반복
        lottieView.play { completion in
            self.dismiss(animated: true)
//            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
    // 알람 설정 BottomSheet
    @objc func showNotificationBottomSheet() {
        notivc.setPreViewController(self)
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: notivc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 317
        bottomSheet.dismissOnDraggingDownSheet = false
        
        self.present(bottomSheet, animated: true, completion: nil)
    }
    // 새 폴더 추가 BottomSheet
    @objc func showAddNewFolderBottomSheet() {
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: newFoldervc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 317
        bottomSheet.dismissOnDraggingDownSheet = false
        
        self.present(bottomSheet, animated: true, completion: nil)
    }
}
// MARK: - CollectionView delegate
extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let count = wishListData.count ?? 0
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCollectionViewCell.identifier,
                                                            for: indexPath)
                as? FolderCollectionViewCell else{ fatalError() }
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 10
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let itemDetailVC = ItemDetailViewController()
//        itemDetailVC.modalPresentationStyle = .fullScreen
//        self.present(itemDetailVC, animated: true, completion: nil)
    }
    
    func setTempData() {
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item1", itemPrice: 1000, isCart: true))
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item2", itemPrice: 2000, isCart: false))
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item3", itemPrice: 3000, isCart: false))
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item4", itemPrice: 4000, isCart: true))
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item5", itemPrice: 5000, isCart: true))
    }
}
