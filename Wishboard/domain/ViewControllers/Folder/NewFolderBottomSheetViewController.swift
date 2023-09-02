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
        completeButton.isActivate = false
    }
    /// 분기처리: 폴더명 input 이 유효할 때
    func folderTextCountValid(_ folderInput: String) {
        textFieldCountLabel.text = "(" + String(folderInput.count) + "/10)자"
        
        errorMessage.isHidden = true
        completeButton.isActivate = true
        folderStr = folderInput
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
