//
//  SetFolderBottomSheetViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/14.
//

import UIKit

class SetFolderBottomSheetViewController: UIViewController {
    var setFolderBottomSheetView: SetFolderBottomSheetView!

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
    @objc func goBack() {
        self.dismiss(animated: true)
    }
}
// MARK: - TableView delegate
extension SetFolderBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FolderListTableViewCell", for: indexPath) as? FolderListTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
