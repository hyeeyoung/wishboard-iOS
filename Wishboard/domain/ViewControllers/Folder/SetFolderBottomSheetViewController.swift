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
    var selectedIdx: Int!
    var preVC: UploadItemViewController!

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
    }
    override func viewWillDisappear(_ animated: Bool) {
        let indexPath = IndexPath(row: 3, section: 0)
        self.preVC.uploadItemView.uploadItemTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    func setPreViewController(_ preVC: UploadItemViewController) {
        self.preVC = preVC
    }
    @objc func goBack() {
        self.dismiss(animated: true)
    }
}
// MARK: - TableView delegate
extension SetFolderBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.folderListData.count ?? 0
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FolderListTableViewCell", for: indexPath) as? FolderListTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        if indexPath.row == self.selectedIdx {cell.checkIcon.isHidden = false}
        else {cell.checkIcon.isHidden = true}
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idx = indexPath.row
        self.selectedIdx = idx
        setFolderBottomSheetView.folderTableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension SetFolderBottomSheetViewController {
    func setTempData() {
        self.folderListData.append(FolderListModel(folderImage: "", folderName: "상의", isChecked: true))
        self.folderListData.append(FolderListModel(folderImage: "", folderName: "하의", isChecked: false))
        self.folderListData.append(FolderListModel(folderImage: "", folderName: "아우터", isChecked: false))
        self.folderListData.append(FolderListModel(folderImage: "", folderName: "악세서리", isChecked: false))
        self.folderListData.append(FolderListModel(folderImage: "", folderName: "가방", isChecked: false))
        
        self.setFolderBottomSheetView.folderTableView.reloadData()
    }
}
