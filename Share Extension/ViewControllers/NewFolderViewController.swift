//
//  NewFolderViewController.swift
//  Share Extension
//
//  Created by gomin on 2022/09/25.
//

import UIKit
import Lottie

class NewFolderViewController: KeyboardViewController {
    let titleLabel = UILabel().then{
        $0.text = "새 폴더 추가"
        $0.font = UIFont.Suit(size: 14, family: .Bold)
    }
    let exitBtn = UIButton().then{
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    let newFolderTextField = UITextField().then{
        $0.addLeftPadding(10)
        $0.backgroundColor = .wishboardTextfieldGray
        $0.layer.cornerRadius = 5
        $0.font = UIFont.Suit(size: 16, family: .Regular)
        $0.textColor = .wishboardGray
        $0.clearButtonMode = .whileEditing
        $0.placeholder = "폴더명"
    }
    let textFieldCountLabel = UILabel().then{
        $0.text = "(0/10)자"
        $0.textColor = .wishboardGray
        $0.font = UIFont.Suit(size: 12, family: .Regular)
    }
    let errorMessage = UILabel().then{
        $0.text = "동일이름의 폴더가 있어요!"
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textColor = .wishboardRed
    }
    let completeButton = UIButton().then{
        $0.defaultButton("추가", .wishboardGreen, .black)
    }
    // MARK: - Life Cycles
    var folderStr: String!
    var tempFolderStr: String!
    var isAddSuccess: Bool = false
    var preVC: ShareViewController!
    
    var lottieView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.textfield = self.newFolderTextField
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.view.roundCornersDiffernt(topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0)

        setUpView()
        setUpConstraint()
        
        self.errorMessage.isHidden = true
        self.completeButton.isEnabled = false
        self.completeButton.defaultButton("추가", .wishboardDisabledGray, .gray)
        
        self.newFolderTextField.addTarget(self, action: #selector(folderTextFieldEditingChanged(_:)), for: .editingChanged)
        self.exitBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        self.completeButton.addTarget(self, action: #selector(addNewFolderButtonDidTap), for: .touchUpInside)
    }
    override func viewDidDisappear(_ animated: Bool) {
        if let preVC = self.preVC {
            if isAddSuccess {FolderDataManager().getFolderListDataManager(preVC)}
        }
    }
    // MARK: - Functions
    func setUpView() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(exitBtn)
        self.view.addSubview(newFolderTextField)
        self.view.addSubview(textFieldCountLabel)
        self.view.addSubview(errorMessage)
        self.view.addSubview(completeButton)
    }
    func setUpConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        exitBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
        }
        newFolderTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(82)
            make.height.equalTo(42)
        }
        textFieldCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(newFolderTextField)
            make.top.equalTo(newFolderTextField.snp.bottom).offset(5)
        }
        errorMessage.snp.makeConstraints { make in
            make.leading.equalTo(newFolderTextField)
            make.top.equalTo(newFolderTextField.snp.bottom).offset(6)
        }
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(newFolderTextField.snp.bottom).offset(86)
        }
    }
    // MARK: - Actions
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    @objc func addNewFolderButtonDidTap() {
        lottieView = self.completeButton.setHorizontalLottieView(self.completeButton)
        self.completeButton.isSelected = true
        lottieView.isHidden = false
        lottieView.play { completion in
            let addFolderInput = AddFolderInput(folder_name: self.folderStr)
            FolderDataManager().addFolderDataManager(addFolderInput, self)
        }
        
    }
    @objc func folderTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        
        textFieldCountLabel.text = "(" + String(text.count) + "/10)자"
        self.tempFolderStr = text
        if text.count > 10 {self.checkValidFolder(self.tempFolderStr, false)}
        else {self.checkValidFolder(self.tempFolderStr, true)}
    }
    func checkValidFolder(_ folder: String, _ isValidCount: Bool) {
        // TODO: 유효한 폴더명인 지 확인 필요
        if isValidCount {
            self.textFieldCountLabel.textColor = .wishboardGray
            self.errorMessage.isHidden = true
            self.completeButton.isSelected = false
            self.completeButton.defaultButton("추가", .wishboardGreen, .black)
            self.completeButton.isEnabled = true
            self.folderStr = self.tempFolderStr
        } else {
            self.textFieldCountLabel.textColor = .wishboardRed
            self.errorMessage.isHidden = true
            self.completeButton.isSelected = false
            self.completeButton.defaultButton("추가", .wishboardDisabledGray, .gray)
            self.completeButton.isEnabled = false
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
        
        print(result.message)
    }
    func addFolderAPIFail() {
        self.lottieView.isHidden = true
        self.completeButton.reloadInputViews()
        self.errorMessage.isHidden = false
        self.completeButton.defaultButton("추가", .wishboardDisabledGray, .gray)
        self.completeButton.isEnabled = false
    }
}
