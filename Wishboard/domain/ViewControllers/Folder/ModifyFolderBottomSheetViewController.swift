//
//  ModifyFolderBottomSheetViewController.swift
//  Wishboard
//
//  Created by gomin on 2023/06/12.
//

import Foundation
import UIKit
import Lottie


class ModifyFolderBottomSheetViewController: BottomSheetKeyboardViewController {
    // MARK: - Life Cycles
    var folderStr: String!
    var preVC: FolderViewController!
    
    var folderData: FolderModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func initComponents() {
        // bottom sheet title
        titleLabel.text = Title.modifyFolder
        
        // textfield placeholder
        textfield = DefaultTextField(Placeholder.folder).then{
            $0.clearButtonMode = .whileEditing
            $0.text = folderData.folder_name
        }
        
        // complete button
        completeButton = LoadingButton(Button.modify).then{
            $0.activateButton()
        }
        
        // folder name count label
        if let foldername = folderData.folder_name {
            textFieldCountLabel.text = "(" + String(foldername.count) + "/10)자"
            folderTextCountValid(foldername)
        }
        
        // error message text
        errorMessage.text = ErrorMessage.sameFolderName
        errorMessage.isHidden = true
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    // MARK: - Actions
    @objc override func completeButtonDidTap() {
        UIDevice.vibrate()
        
        completeButton.startLoadingAnimation()
        
        let folderId = folderData.folder_id
        let addFolderInput = AddFolderInput(folder_name: self.folderStr!)
        FolderDataManager().modifyFolderDataManager(folderId!, addFolderInput, self, self.preVC)
    }
    override func textFieldEditingChanged(_ sender: UITextField) {
        let folderInput = sender.text ?? ""

        // 폴더명 input 분기처리
        if folderInput.isEmpty { setFolderTextCountEmpty()}
        else if folderInput.count > 10 {setFolderTextCountOver10(sender)}
        else {folderTextCountValid(folderInput)}
    }
    /// 분기처리: 폴더명 input 의 카운트가 10 초과 시
    func setFolderTextCountOver10(_ sender: UITextField) {
        textFieldCountLabel.text = "(10/10)자"
        sender.text = folderStr
        return
    }
    /// 분기처리: 폴더명 input 이 비어있을 시
    func setFolderTextCountEmpty() {
        textFieldCountLabel.text = "(0/10)자"
        errorMessage.isHidden = true
        completeButton.inactivateButton()
    }
    /// 분기처리: 폴더명 input 이 유효할 때
    func folderTextCountValid(_ folderInput: String) {
        textFieldCountLabel.text = "(" + String(folderInput.count) + "/10)자"
        
        errorMessage.isHidden = true
        completeButton.activateButton()
        folderStr = folderInput
    }
}
// MARK: - API Success
extension ModifyFolderBottomSheetViewController {
    func sameFolderNameFail() {
        completeButton.reloadInputViews()
        errorMessage.isHidden = false
        
        completeButton.inactivateButton()
    }
}
