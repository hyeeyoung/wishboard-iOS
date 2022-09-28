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
    var selectedFolderIndex: Int?     // 선택된 폴더 인덱스 (체크표시)
    var preUploadVC: UploadItemViewController!
    var preItemDetailVC: ItemDetailViewController!

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
            let indexPath = IndexPath(row: 3, section: 0)
            preVC.uploadItemView.uploadItemTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        FolderDataManager().getFolderListDataManager(self)
        print(self.selectedFolder, self.selectedFolderId)
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
        if let selectedFolderIndex = self.selectedFolderIndex {
            if selectedFolderIndex == itemIdx {
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
        self.selectedFolderIndex = idx
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true)
    }
}
// MARK: - API Success
extension SetFolderBottomSheetViewController {
    func getFolderListAPISuccess(_ result: [FolderListModel]) {
        self.folderListData = result
        setFolderBottomSheetView.folderTableView.reloadData()
    }
    func getFolderListAPIFail() {
        FolderDataManager().getFolderListDataManager(self)
    }
}
