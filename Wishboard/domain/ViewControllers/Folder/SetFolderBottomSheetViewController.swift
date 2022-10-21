//
//  SetFolderBottomSheetViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/14.
//

import UIKit

class SetFolderBottomSheetViewController: UIViewController {
    var setFolderBottomSheetView: SetFolderBottomSheetView!
    var folderListData: [FolderListModel] = []
    var selectedFolder: String?     // 선택된 폴더 이름
    var selectedFolderId: Int?     // 선택된 폴더 id (서버로 전송될 folder_id값)
    var preUploadVC: UploadItemViewController!
    var preItemDetailVC: ItemDetailViewController!
    var itemId: Int?    // 아이템 폴더 수정 시 itemId

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.view.roundCornersDiffernt(topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0)

        setFolderBottomSheetView = SetFolderBottomSheetView()
        self.view.addSubview(setFolderBottomSheetView)
        
        setFolderBottomSheetView.setTableView(dataSourceDelegate: self)
        setFolderBottomSheetView.setUpView()
        setFolderBottomSheetView.setUpConstraint()
        
        setFolderBottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        setFolderBottomSheetView.exitBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        // DATA
        FolderDataManager().getFolderListDataManager(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let preVC = self.preUploadVC {
            let indexPath = IndexPath(row: 2, section: 0)
            preVC.wishListData.folder_id = self.selectedFolderId
            preVC.wishListData.folder_name = self.selectedFolder
            preVC.uploadItemView.uploadContentTableView.reloadRows(at: [indexPath], with: .automatic)
            preVC.view.endEditing(true)
        }
        if let preVC = self.preItemDetailVC {
            if let itemId = self.itemId {
                ItemDataManager().getItemDetailDataManager(itemId, preVC)
            }
            preVC.itemDetailView.itemDetailTableView.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        FolderDataManager().getFolderListDataManager(self)
        print(self.selectedFolder, self.selectedFolderId)
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    func setPreViewController(_ preVC: UploadItemViewController) {
        self.preUploadVC = preVC
    }
    func setPreViewController(_ preVC: ItemDetailViewController) {
        self.preItemDetailVC = preVC
    }
    @objc func goBack() {
        self.dismiss(animated: true)
    }
}
// MARK: - TableView delegate
extension SetFolderBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.folderListData.count ?? 0
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FolderListTableViewCell", for: indexPath) as? FolderListTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let itemIdx = indexPath.item
        cell.setUpData(self.folderListData[itemIdx])
        if let selectedFolderId = self.selectedFolderId {
            if selectedFolderId == self.folderListData[itemIdx].folder_id {
                cell.checkIcon.isHidden = false
            } else {
                cell.checkIcon.isHidden = true
            }
        } else {
            if itemIdx == 0 {cell.checkIcon.isHidden = false}
            else {cell.checkIcon.isHidden = true}
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idx = indexPath.row
        self.selectedFolder = folderListData[idx].folder_name
        self.selectedFolderId = folderListData[idx].folder_id
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let itemId = self.itemId {
            FolderDataManager().modifyItemFolderDataManager(itemId, self.selectedFolderId!, self)
        }
        self.dismiss(animated: true)
    }
}
// MARK: - API Success
extension SetFolderBottomSheetViewController {
    // MARK: 폴더 리스트 가져오기
    func getFolderListAPISuccess(_ result: [FolderListModel]) {
        self.folderListData = result
        // reload data with animation
        UIView.transition(with: setFolderBottomSheetView.folderTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                            self.setFolderBottomSheetView.folderTableView.reloadData()},
                          completion: nil);
    }
    func getFolderListAPIFail() {
        FolderDataManager().getFolderListDataManager(self)
    }
    // MARK: 아이템의 폴더 수정
    func modifyItemFolderAPISuccess(_ result: APIModel<ResultModel>) {
        self.dismiss(animated: true)
        print(result.message)
    }
}
