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
    var selectedFolder: String?
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
        setTempData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let preVC = self.preUploadVC {
            let indexPath = IndexPath(row: 3, section: 0)
            preVC.uploadItemView.uploadItemTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        if let preVC = self.preItemDetailVC {
            preVC.selectedFolder = self.selectedFolder
            preVC.itemDetailView.itemDetailTableView.reloadData()
        }
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
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idx = indexPath.row
        self.selectedFolder = folderListData[idx].folderName
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true)
    }
}
extension SetFolderBottomSheetViewController {
    func setTempData() {
        self.folderListData.append(FolderListModel(folderImage: "", folderName: "상의", isChecked: true))
        self.folderListData.append(FolderListModel(folderImage: "", folderName: "하의", isChecked: false))
        self.folderListData.append(FolderListModel(folderImage: "", folderName: "아우터", isChecked: false))
        self.folderListData.append(FolderListModel(folderImage: "", folderName: "악세서리", isChecked: false))
        self.folderListData.append(FolderListModel(folderImage: "", folderName: "가방", isChecked: false))
        
        print(self.folderListData[1])
        self.setFolderBottomSheetView.folderTableView.reloadData()
    }
}
