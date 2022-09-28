//
//  FolderViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit
import Lottie

class FolderViewController: UIViewController {
    var folderView : FolderView!
    let emptyMessage = "앗, 폴더가 없어요!\n폴더를 추가해서 아이템을 정리해 보세요!"
    var dialog: PopUpWithTextFieldViewController!
    var folderData: [FolderModel] = []
    var folderStr: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true

        setFolderView()
        FolderDataManager().getFolderDataManager(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        FolderDataManager().getFolderDataManager(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        FolderDataManager().getFolderDataManager(self)
    }

}
// MARK: - CollectionView delegate
extension FolderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = folderData.count ?? 0
        EmptyView().setEmptyView(self.emptyMessage, self.folderView.folderCollectionView, count)
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCollectionViewCell.identifier,
                                                            for: indexPath)
                as? FolderCollectionViewCell else{ fatalError() }
        let itemIdx = indexPath.item
        cell.setUpData(self.folderData[itemIdx])
        
        let folderMenuGesture = CustomButton(target: self, action: #selector(alertFolderMenu(_:)))
        folderMenuGesture.folderData = self.folderData[itemIdx]
        cell.moreButton.addGestureRecognizer(folderMenuGesture)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemIdx = indexPath.item
        let folderName = self.folderData[itemIdx].folder_name
        let folderId = self.folderData[itemIdx].folder_id
        let folderDetailVC = FolderDetailViewController()
        folderDetailVC.folderName = folderName
        folderDetailVC.folderId = folderId
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
    @objc func alertFolderMenu(_ sender: CustomButton) {
        guard let folderData = sender.folderData else {return}
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction =  UIAlertAction(title: "폴더명 수정", style: UIAlertAction.Style.default){(_) in
            self.alertModifyDialog(folderData: folderData)
        }
        let deleteAction =  UIAlertAction(title: "폴더 삭제", style: UIAlertAction.Style.default){(_) in
            self.alertDeleteDialog(folderData: folderData)
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.view.tintColor = .black
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }
    // 폴더 추가 팝업창
    @objc func alertAddDialog() {
        dialog = PopUpWithTextFieldViewController(titleText: "폴더 추가", placeholder: "폴더명", prevText: nil, buttonTitle: "추가")
        dialog.modalPresentationStyle = .overCurrentContext
        dialog.completeButton.addTarget(self, action: #selector(completeAddButtonDidTap), for: .touchUpInside)
        dialog.textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.present(dialog, animated: false, completion: nil)
    }
    // 폴더명 수정 팝업창
    func alertModifyDialog(folderData: FolderModel) {
        dialog = PopUpWithTextFieldViewController(titleText: "폴더명 수정", placeholder: "폴더명", prevText: folderData.folder_name, buttonTitle: "수정")
        dialog.modalPresentationStyle = .overCurrentContext
        let folderMenuGesture = CustomButton(target: self, action: #selector(completeModifyButtonDidTap(_:)))
        folderMenuGesture.folderData = folderData
        dialog.completeButton.addGestureRecognizer(folderMenuGesture)
        dialog.textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.present(dialog, animated: false, completion: nil)
    }
    // 폴더 삭제 팝업창
    func alertDeleteDialog(folderData: FolderModel) {
        let dialog = PopUpViewController(titleText: "폴더 삭제", messageText: "정말 폴더를 삭제하시겠어요?\n폴더가 삭제되어도 아이템은 사라지지 않아요.", greenBtnText: "취소", blackBtnText: "삭제")
        dialog.modalPresentationStyle = .overCurrentContext
        self.present(dialog, animated: false, completion: nil)
        
        let folderMenuGesture = CustomButton(target: self, action: #selector(deleteFolderButtonDidTap(_:)))
        folderMenuGesture.folderData = folderData
        dialog.okBtn.addGestureRecognizer(folderMenuGesture)
    }
    // 폴더 삭제 버튼 클릭
    @objc func deleteFolderButtonDidTap(_ sender: CustomButton) {
        guard let folderId = sender.folderData?.folder_id else {return}
        FolderDataManager().deleteFolderDataManager(folderId, self)
    }
    // 폴더명 수정 버튼 클릭
    @objc func completeModifyButtonDidTap(_ sender: CustomButton) {
        let folderId = sender.folderData?.folder_id
        let lottieView = dialog.completeButton.setHorizontalLottieView(dialog.completeButton)
        dialog.completeButton.isSelected = true
        lottieView.isHidden = false
        lottieView.play { completion in
            let addFolderInput = AddFolderInput(folder_name: self.folderStr)
            FolderDataManager().modifyFolderDataManager(folderId!, addFolderInput, self)
        }
    }
    // 폴더 추가 버튼 클릭
    @objc func completeAddButtonDidTap() {
        let lottieView = dialog.completeButton.setHorizontalLottieView(dialog.completeButton)
        dialog.completeButton.isSelected = true
        lottieView.isHidden = false
        lottieView.play { completion in
            let addFolderInput = AddFolderInput(folder_name: self.folderStr)
            FolderDataManager().addFolderDataManager(addFolderInput, self)
        }
    }
    // 팝업창 - 텍스트필드 감지
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.folderStr = text
    }
}
// MARK: - API Success
extension FolderViewController {
    // MARK: 폴더 조회 API
    func getFolderAPISuccess(_ result: [FolderModel]) {
        self.folderData = result
        // reload data with animation
        UIView.transition(with: folderView.folderCollectionView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                              self.folderView.folderCollectionView.reloadData()},
                          completion: nil);
    }
    func getFolderAPIFail() {
        FolderDataManager().getFolderDataManager(self)
    }
    // MARK: 폴더 추가 API
    func addFolderAPISuccess(_ result: APIModel<ResultModel>) {
        self.folderStr = ""
        self.dismiss(animated: false)
        SnackBar(self, message: .addFolder)
        FolderDataManager().getFolderDataManager(self)
        print(result.message)
    }
    // MARK: 폴더명 수정 API
    func modifyFolderAPISuccess(_ result: APIModel<ResultModel>) {
        self.folderStr = ""
        self.dismiss(animated: false)
        SnackBar(self, message: .modifyFolder)
        FolderDataManager().getFolderDataManager(self)
        print(result.message)
    }
    func modifyFolderAPIFail() {
        self.dismiss(animated: false)
        print("폴더명 수정 Error")
    }
    // MARK: 폴더 삭제 API
    func deleteFolderAPISuccess(_ result: APIModel<ResultModel>) {
        self.dismiss(animated: false)
        SnackBar(self, message: .deleteFolder)
        FolderDataManager().getFolderDataManager(self)
        print(result.message)
    }
}
// MARK: - 버튼 클릭 Gesture Recognizer
class CustomButton: UITapGestureRecognizer {
    var folderData: FolderModel?
}
