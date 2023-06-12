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
        lottieView = self.completeButton.setLottieView()
        lottieView.play { completion in
            let addFolderInput = AddFolderInput(folder_name: self.folderStr)
            FolderDataManager().addFolderDataManager(addFolderInput, self)
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
            self.textFieldCountLabel.textColor = .gray_200
            self.completeButton.isActivate = true
            self.folderStr = self.tempFolderStr
        } else {
            errorMessage.isHidden = true
            self.textFieldCountLabel.textColor = .pink_700
            self.completeButton.isActivate = false
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
        
        self.textFieldCountLabel.textColor = .gray_200
        self.errorMessage.isHidden = true
        self.completeButton.inActivateLottieView()
        self.completeButton.isActivate = true
        
        print(result.message)
    }
    func sameFolderNameFail() {
        self.completeButton.reloadInputViews()
        self.errorMessage.isHidden = false
        self.completeButton.inActivateLottieView()
    }
    func addFolderAPIFail() {
        let addFolderInput = AddFolderInput(folder_name: self.folderStr)
        FolderDataManager().addFolderDataManager(addFolderInput, self)
    }
}
