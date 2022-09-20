//
//  FolderViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class FolderViewController: UIViewController {
    var folderView : FolderView!
    let emptyMessage = "앗, 폴더가 없어요!\n폴더를 추가해서 아이템을 정리해 보세요!"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true

        setFolderView()
    }
    

}
// MARK: - CollectionView delegate
extension FolderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let count = wishListData.count ?? 0
        EmptyView().setEmptyView(self.emptyMessage, self.folderView.folderCollectionView, 7)
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCollectionViewCell.identifier,
                                                            for: indexPath)
                as? FolderCollectionViewCell else{ fatalError() }
        let itemIdx = indexPath.item
//        cell.setUpData(self.wishListData[itemIdx])
        
        cell.moreButton.addTarget(self, action: #selector(alertFolderMenu), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let folderDetailVC = FolderDetailViewController()
        folderDetailVC.modalPresentationStyle = .fullScreen
        self.present(folderDetailVC, animated: true, completion: nil)
    }
}
// MARK: - Functions & Actions
extension FolderViewController {
    func setFolderView() {
        folderView = FolderView()
        self.view.addSubview(folderView)
        
        folderView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        folderView.setCollectionView(self)
        folderView.setUpView()
        folderView.setUpConstraint()
        
        folderView.plusButton.addTarget(self, action: #selector(alertAddDialog), for: .touchUpInside)
    }
    // 폴더 메뉴 하단 팝업창
    @objc func alertFolderMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let modifyAction =  UIAlertAction(title: "폴더명 수정", style: UIAlertAction.Style.default){(_) in
            self.alertModifyDialog()
        }
        let deleteAction =  UIAlertAction(title: "폴더 삭제", style: UIAlertAction.Style.default){(_) in
            self.alertDeleteDialog()
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.view.tintColor = .black
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }
    func alertModifyDialog() {
        let dialog = PopUpWithTextFieldViewController(titleText: "폴더명 수정", placeholder: "폴더명", prevText: "폴더명", buttonTitle: "수정")
        dialog.modalPresentationStyle = .overCurrentContext
        self.present(dialog, animated: false, completion: nil)
    }
    func alertDeleteDialog() {
        let dialog = PopUpViewController(titleText: "폴더 삭제", messageText: "정말 폴더를 삭제하시겠어요?\n폴더가 삭제되어도 아이템은 사라지지 않아요.", greenBtnText: "취소", blackBtnText: "삭제")
        dialog.modalPresentationStyle = .overCurrentContext
        self.present(dialog, animated: false, completion: nil)
    }
    @objc func alertAddDialog() {
        let dialog = PopUpWithTextFieldViewController(titleText: "폴더 추가", placeholder: "폴더명", prevText: nil, buttonTitle: "추가")
        dialog.modalPresentationStyle = .overCurrentContext
        self.present(dialog, animated: false, completion: nil)
    }
}
