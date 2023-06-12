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
    var tempFolderStr: String!
    var preVC: FolderViewController!
    
    var folderData: FolderModel!
    
    var lottieView: LottieAnimationView!
    
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
        completeButton = DefaultButton(titleStr: Button.modify).then{
            $0.isActivate = true
        }
        
        // folder name count label
        if let foldername = folderData.folder_name {
            textFieldCountLabel.text = "(" + String(foldername.count) + "/10)자"
            self.tempFolderStr = foldername
            checkValidFolder(self.tempFolderStr, true)
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
        let folderId = folderData.folder_id
        
        lottieView = completeButton.setLottieView()
        lottieView.play { completion in
            self.lottieView.loopMode = .loop
            let addFolderInput = AddFolderInput(folder_name: self.folderStr!)
            FolderDataManager().modifyFolderDataManager(folderId!, addFolderInput, self, self.preVC)
        }
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
            textFieldCountLabel.textColor = .gray_200
            completeButton.isActivate = true
            folderStr = self.tempFolderStr
        } else {
            errorMessage.isHidden = true
            textFieldCountLabel.textColor = .pink_700
            completeButton.isActivate = false
        }
    }
}
// MARK: - API Success
extension ModifyFolderBottomSheetViewController {
    func sameFolderNameFail() {
        completeButton.reloadInputViews()
        errorMessage.isHidden = false
        
        completeButton.inActivateLottieView()
        lottieView.isHidden = true
    }
}
