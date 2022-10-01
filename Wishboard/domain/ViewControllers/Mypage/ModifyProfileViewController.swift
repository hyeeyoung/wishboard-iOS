//
//  ModifyProfileViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class ModifyProfileViewController: TitleCenterViewController {
    // profile
    var profileImage = UIImageView().then{
        $0.image = UIImage(named: "defaultProfile")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 53
        $0.contentMode = .scaleToFill
    }
    let cameraButton = UIButton().then{
        $0.setImage(UIImage(named: "camera_gray"), for: .normal)
    }
    var nameTextField = UITextField().then{
        $0.placeholder = "닉네임을 수정해주세요."
        $0.addLeftPadding(10)
        $0.backgroundColor = .wishboardTextfieldGray
        $0.layer.cornerRadius = 5
        $0.font = UIFont.Suit(size: 16, family: .Regular)
        $0.clearButtonMode = .whileEditing
    }
    let completeButton = UIButton().then{
        $0.defaultButton("완료", .wishboardGreen, .black)
    }
    // MARK: - Life Cycles
    // 앨범 선택 image picker
    var isPhotoSelected = false
    var isNicknameChanged = false
    let imagePickerController = UIImagePickerController()
    var selectedPhoto: UIImage!
    var nickname: String?
    
    var preNickName: String?
    var preProfileImg: String?
    var preVC: MyPageViewController!
    var modified: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        super.navigationTitle.text = "프로필 수정"
        
        // imagePicker delegate
        imagePickerController.delegate = self
        
        setUpView()
        setUpConstraint()
        setTarget()
        
        self.nameTextField.delegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        if modified {
            SnackBar(preVC, message: .modifyProfile)
            MypageDataManager().getUserInfoDataManager(preVC)
        }
    }
}
// MARK: - Set Views
extension ModifyProfileViewController {
    func setUpView() {
        self.view.addSubview(profileImage)
        self.view.addSubview(cameraButton)
        self.view.addSubview(nameTextField)
        self.view.addSubview(completeButton)
        
        if let image = self.preProfileImg {
            self.profileImage.kf.setImage(with: URL(string: image), placeholder: UIImage())
        }
        nameTextField.text = self.preNickName
    }
    func setUpConstraint() {
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(106)
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(45)
        }
        cameraButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(24)
            make.trailing.bottom.equalTo(profileImage)
        }
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.top.equalTo(profileImage.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
    }
}
// MARK: Set Targets
extension ModifyProfileViewController {
    func setTarget() {
        self.cameraButton.addTarget(self, action: #selector(goAlbumButtonDidTap), for: .touchUpInside)
        self.nameTextField.addTarget(self, action: #selector(nameTextFieldEditingChanged(_:)), for: .editingChanged)
        self.completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }
    @objc func nameTextFieldEditingChanged(_ sender: UITextField) {
        self.isNicknameChanged = true
        let text = sender.text ?? ""
        self.nickname = text
    }
    // 앨범에서 사진/동영상 선택
    @objc func goAlbumButtonDidTap() {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @objc func completeButtonDidTap() {
        let lottieView = self.completeButton.setHorizontalLottieView(self.completeButton)
        self.completeButton.isSelected = true
        lottieView.isHidden = false
        lottieView.play { completion in
            if self.isPhotoSelected && self.isNicknameChanged {
                ModifyProfileDataManager().modifyProfileDataManager(self.nickname!, self.selectedPhoto, self)
            } else if self.isNicknameChanged {
                let modifyProfileInput = ModifyProfileInputNickname(nickname: self.nickname)
                ModifyProfileDataManager().modifyProfileDataManager(modifyProfileInput, self)
            } else if self.isPhotoSelected {
                ModifyProfileDataManager().modifyProfileDataManager(self.selectedPhoto, self)
            } else {
                self.dismiss(animated: true)
            }
            
        }
    }
}
// MARK: - ImagePicker Delegate
extension ModifyProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.selectedPhoto = UIImage()
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedPhoto = image
            self.profileImage.image = image
            self.isPhotoSelected = true
        }
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - Textfield delegate
extension ModifyProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.bounds.origin.y = 0.0
        return true
    }
}
// MARK: - API Success
extension ModifyProfileViewController {
    func modifyProfileAPISuccess(_ result: APIModel<ResultModel>) {
        if result.success! {
            self.modified = true
            self.dismiss(animated: true)
        } else {}
        
        print(result.message)
    }
}
