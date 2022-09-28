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
    var folderListData: [FolderListModel] = []
    var notivc: NotificationSettingViewController!
    var newFoldervc: NewFolderViewController!
    
    var selectedFolder: String?
    var selectedFolderIdx: Int?
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        setUpShareView()
        FolderDataManager().getFolderListDataManager(self)
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
        let count = folderListData.count ?? 0
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCollectionViewCell.identifier,
                                                            for: indexPath)
                as? FolderCollectionViewCell else{ fatalError() }
        let itemIdx = indexPath.row
        cell.setUpData(self.folderListData[itemIdx])
        
        if let selectedFolderIdx = self.selectedFolderIdx {
            if selectedFolderIdx == self.folderListData[itemIdx].folder_id {
                cell.setSelectedFolder(true)
            } else {
                cell.setSelectedFolder(false)
            }
        } else {
            if itemIdx == 0 {cell.setSelectedFolder(true)}
            else {cell.setSelectedFolder(false)}
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemIdx = indexPath.item
        self.selectedFolderIdx = self.folderListData[itemIdx].folder_id!
        print(self.selectedFolderIdx)
        shareView.folderCollectionView.reloadData()
    }
}
// MARK: - API Success
extension ShareViewController {
    // MARK: 폴더 리스트 조회 API
    func getFolderListAPISuccess(_ result: [FolderListModel]) {
        self.folderListData = result
        shareView.folderCollectionView.reloadData()
    }
    func getFolderListAPIFail() {
        FolderDataManager().getFolderListDataManager(self)
    }
}
