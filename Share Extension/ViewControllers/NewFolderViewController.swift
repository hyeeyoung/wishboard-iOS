//
//  NewFolderViewController.swift
//  Share Extension
//
//  Created by gomin on 2022/09/25.
//

import UIKit
import Lottie

class NewFolderViewController: BottomSheetKeyboardViewController {
    // MARK: - Life Cycles
    var folderStr: String!
    var tempFolderStr: String!
    var isAddSuccess: Bool = false
    var preVC: ShareViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func initComponents() {
        // bottom sheet title
        titleLabel.text = Title.addFolder
        
        // textfield placeholder
        textfield = DefaultTextField(Placeholder.folder).then{
            $0.clearButtonMode = .whileEditing
        }
        
        // error message text
        errorMessage.text = ErrorMessage.sameFolderName
        errorMessage.isHidden = true
        
        // complete button
        completeButton = LoadingButton(Button.add).then{
            $0.activateButton()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let preVC = self.preVC {
            if isAddSuccess {FolderDataManager().getFolderListDataManager(preVC)}
            preVC.view.endEditing(true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    // MARK: - Actions
    @objc override func completeButtonDidTap() {
        UIDevice.vibrate()
        
        completeButton.startLoadingAnimation()
        let addFolderInput = AddFolderInput(folder_name: self.folderStr)
        FolderDataManager().addFolderDataManager(addFolderInput, self)
    }
    override func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""

        textFieldCountLabel.text = "(" + String(text.count) + "/10)자"
        self.tempFolderStr = text
        if text.count > 10 || text.isEmpty {self.checkValidFolder(self.tempFolderStr, false)}
        else {self.checkValidFolder(self.tempFolderStr, true)}
    }
    
    func checkValidFolder(_ folder: String, _ isValidCount: Bool) {
        // TODO: 유효한 폴더명인 지 확인 필요
        if isValidCount {
            errorMessage.isHidden = true
            self.completeButton.activateButton()
            self.folderStr = self.tempFolderStr
        } else {
            errorMessage.isHidden = true
            self.completeButton.inactivateButton()
        }
    }
}
// MARK: - API Success
extension NewFolderViewController {
    // MARK: 새 폴더 추가 API
    func addFolderAPISuccess(_ result: APIModel<ResultModel>) {
        self.isAddSuccess = true
        self.viewDidLoad()
        self.dismiss(animated: true)
        
        errorMessage.isHidden = true
        completeButton.activateButton()
        
        print(result.message)
    }
    func sameFolderNameFail() {
        completeButton.reloadInputViews()
        errorMessage.isHidden = false
        completeButton.inactivateButton()
    }
    func addFolderAPIFail() {
        let addFolderInput = AddFolderInput(folder_name: self.folderStr)
        FolderDataManager().addFolderDataManager(addFolderInput, self)
    }
}
