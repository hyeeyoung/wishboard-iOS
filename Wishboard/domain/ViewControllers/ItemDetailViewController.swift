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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        itemDetailView = ItemDetailView()
        self.view.addSubview(itemDetailView)
        
        itemDetailView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        setItemView()
    }
    // MARK: - Actions
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    @objc func alertDialog() {
        let dialog = PopUpViewController(titleText: "아이템 삭제", messageText: "정말 아이템을 삭제하시겠어요?\n삭제된 아이템은 다시 복구할 수 없어요!", greenBtnText: "취소", blackBtnText: "삭제")
        dialog.modalPresentationStyle = .overCurrentContext
        self.present(dialog, animated: false, completion: nil)
        
        dialog.okBtn.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
    }
    @objc func deleteButtonDidTap() {
        self.dismiss(animated: true)
        ScreenManager().goMainPages(0, self, family: .itemDeleted)
    }
    @objc func setFolder() {
        let vc = SetFolderBottomSheetViewController()
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: vc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 317
        bottomSheet.dismissOnDraggingDownSheet = false
        
        self.present(bottomSheet, animated: true, completion: nil)
    }
    @objc func goModify() {
        let modifyVC = UploadItemViewController()
        modifyVC.isUploadItem = false
        
        modifyVC.modalPresentationStyle = .fullScreen
        self.present(modifyVC, animated: true, completion: nil)
    }
}
extension ItemDetailViewController {
    func setItemView() {
        itemDetailView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        itemDetailView.deleteButton.addTarget(self, action: #selector(alertDialog), for: .touchUpInside)
        itemDetailView.modifyButton.addTarget(self, action: #selector(goModify), for: .touchUpInside)
        
        itemDetailView.setTableView(self)
        itemDetailView.setUpNavigationView()
        itemDetailView.setUpLowerView(true)
        itemDetailView.setUpConstraint()
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
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height + 78 + 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
