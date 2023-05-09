//
//  ItemDetailViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit
import MaterialComponents.MaterialBottomSheet

class ItemDetailViewController: UIViewController {
    var itemDetailView: ItemDetailView!
    var itemId: Int!
    var wishListData: WishListModel!
    var preVC: UIViewController!
    var isDeleted: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        itemDetailView = ItemDetailView()
        self.view.addSubview(itemDetailView)
        
        itemDetailView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        setItemView()
        ItemDataManager().getItemDetailDataManager(self.itemId, self)
    }
    override func viewDidAppear(_ animated: Bool) {
        ItemDataManager().getItemDetailDataManager(self.itemId, self)
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        if isDeleted {
            guard let preVC = self.preVC else {return}
            switch preVC {
            case is HomeViewController:
                break
            default:
                SnackBar(preVC, message: .deleteItem)
            }
        }
    }
    // MARK: - Actions
    @objc func goBack() {
        UIDevice.vibrate()
        self.navigationController?.popViewController(animated: true)
    }
    @objc func alertDialog() {
        UIDevice.vibrate()
        let dialog = PopUpViewController(titleText: "아이템 삭제", messageText: "정말 아이템을 삭제하시겠어요?\n삭제된 아이템은 다시 복구할 수 없어요!", greenBtnText: "취소", blackBtnText: "삭제")
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
        
        dialog.okBtn.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
    }
    @objc func deleteButtonDidTap() {
        guard let itemId = self.wishListData.item_id else {return}
        ItemDataManager().deleteItemDataManager(itemId, self)
        UIDevice.vibrate()
    }
    @objc func setFolder() {
        UIDevice.vibrate()
        let vc = SetFolderBottomSheetViewController()
        vc.setPreViewController(self)
        vc.itemId = self.wishListData.item_id
        vc.selectedFolderId = self.wishListData.folder_id
        vc.selectedFolder = self.wishListData.folder_name
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: vc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 317
        bottomSheet.dismissOnDraggingDownSheet = false
        
        self.present(bottomSheet, animated: true, completion: nil)
    }
    @objc func goModify() {
        UIDevice.vibrate()
        let modifyVC = UploadItemViewController().then{
            $0.isUploadItem = false
            $0.wishListModifyData = self.wishListData
            $0.preVC = self
        }
        self.navigationController?.pushViewController(modifyVC, animated: true)
    }
}
extension ItemDetailViewController {
    func setItemView() {
        itemDetailView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        itemDetailView.deleteButton.addTarget(self, action: #selector(alertDialog), for: .touchUpInside)
        itemDetailView.modifyButton.addTarget(self, action: #selector(goModify), for: .touchUpInside)
        
        itemDetailView.setTableView(self)
        itemDetailView.setUpNavigationView()
        if let data = self.wishListData {
            if data.item_url != "" {itemDetailView.isLinkExist(isLinkExist: true)}
            else {itemDetailView.isLinkExist(isLinkExist: false)}
        } else {itemDetailView.isLinkExist(isLinkExist: false)}
        
        itemDetailView.setUpConstraint()
    }
    @objc func linkButtonDidTap() {
        UIDevice.vibrate()
        guard let urlStr = self.wishListData.item_url else {return}
        ScreenManager().linkTo(viewcontroller: self, urlStr)
    }
}
// MARK: - TableView delegate
extension ItemDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailTableViewCell", for: indexPath) as? ItemDetailTableViewCell else { return UITableViewCell() }
        
        cell.setFolderButton.addTarget(self, action: #selector(setFolder), for: .touchUpInside)
        if let cellData = self.wishListData {
            cell.setUpData(cellData)
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - API Success
extension ItemDetailViewController {
    // MARK: 아이템 삭제
    func deleteItemAPISuccess(_ result: APIModel<TokenResultModel>) {
        self.dismiss(animated: false)
        self.isDeleted = true
        
        guard let preVC = self.preVC else {return}
        switch preVC {
        case is HomeViewController:
            ScreenManager().goMainPages(0, self, family: .itemDeleted)
            break
        default:
            self.navigationController?.popViewController(animated: true)
        }
        // home o cart x folderdetail x calender x
        
        print(result.message)
    }
    func deleteItemAPIFail() {
        guard let itemId = self.wishListData.item_id else {return}
        ItemDataManager().deleteItemDataManager(itemId, self)
    }
    // MARK: 아이템 상세 조회
    func getItemDetailAPISuccess(_ result: WishListModel) {
        self.wishListData = result
        self.itemDetailView.itemDetailTableView.reloadData()
        // lower view setting
        if let data = self.wishListData {
            if data.item_url != "" {itemDetailView.isLinkExist(isLinkExist: true)}
            else {itemDetailView.isLinkExist(isLinkExist: false)}
        } else {itemDetailView.isLinkExist(isLinkExist: false)}
        itemDetailView.lowerButton.addTarget(self, action: #selector(linkButtonDidTap), for: .touchUpInside)
    }
    func getItemDetailAPIFail() {
//        ItemDataManager().getItemDetailDataManager(self.itemId, self)
    }
}
