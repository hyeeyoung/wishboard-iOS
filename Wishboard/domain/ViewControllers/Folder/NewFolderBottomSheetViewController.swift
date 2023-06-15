//
//  NewFolderBottomSheetViewController.swift
//  Wishboard
//
//  Created by gomin on 2023/06/12.
//

import Foundation
import UIKit
import Lottie


class NewFolderBottomSheetViewController: BottomSheetKeyboardViewController {
    // MARK: - Life Cycles
    var folderStr: String!
    var tempFolderStr: String!
    var preVC: FolderViewController!
    
    var lottieView: LottieAnimationView!
    
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
        completeButton = DefaultButton(titleStr: Button.add).then{
            $0.isActivate = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    // MARK: - Actions
    @objc override func completeButtonDidTap() {
        UIDevice.vibrate()
        lottieView = completeButton.setLottieView()
        
        lottieView.play { completion in
            self.lottieView.loopMode = .loop
            let addFolderInput = AddFolderInput(folder_name: self.folderStr!)
            FolderDataManager().addFolderDataManager(addFolderInput, self, self.preVC)
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
extension NewFolderBottomSheetViewController {
    func sameFolderNameFail() {
        completeButton.reloadInputViews()
        errorMessage.isHidden = false
        completeButton.inActivateLottieView()
    }
    func addFolderAPIFail() {
        let addFolderInput = AddFolderInput(folder_name: self.folderStr)
        FolderDataManager().addFolderDataManager(addFolderInput, self, preVC)
    }
}
