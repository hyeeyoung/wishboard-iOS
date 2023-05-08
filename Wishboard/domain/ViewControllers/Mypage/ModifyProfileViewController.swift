//
//  ModifyProfileViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit
import Kingfisher

class ModifyProfileViewController: TitleCenterViewController {
    // profile
    var profileImage = UIImageView().then{
        $0.image = Image.defaultProfile
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 53
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
    }
    let cameraButton = UIButton().then{
        $0.setImage(Image.cameraGray, for: .normal)
    }
    let nicknameLabel = UILabel().then{
        $0.text = Message.nickName
        $0.font = UIFont.Suit(size: 14, family: .Medium)
    }
    var nameTextField = DefaultTextField(Placeholder.nickname).then{
        $0.clearButtonMode = .always
        $0.becomeFirstResponder()
    }
    let completeButton = DefaultButton(titleStr: Button.complete)
    let completeKeyboardButton = DefaultButton(titleStr: Button.complete)
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 72.0))
    }()
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
        super.navigationTitle.text = Title.modifyProfile
        
        // imagePicker delegate
        imagePickerController.delegate = self
        
        setUpView()
        setUpConstraint()
        setTarget()
        
        nameTextField.inputAccessoryView = accessoryView // <-
        
        self.nameTextField.delegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        if modified {
            print("modify profile")
            preVC.tabBarController?.tabBar.isHidden = false
            SnackBar(preVC, message: .modifyProfile)
            MypageDataManager().getUserInfoDataManager(preVC)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
// MARK: - Set Views
extension ModifyProfileViewController {
    func setUpView() {
        self.view.addSubview(profileImage)
        self.view.addSubview(cameraButton)
        self.view.addSubview(nicknameLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(completeButton)
        
        accessoryView.addSubview(completeKeyboardButton)
        
        if let image = self.preProfileImg {
            let processor = TintImageProcessor(tint: .black_5)
            self.profileImage.kf.setImage(with: URL(string: image), placeholder: UIImage(), options: [.processor(processor)])
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
            make.height.equalTo(26.67)
            make.trailing.bottom.equalTo(profileImage)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
        }
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-34)
        }
        completeKeyboardButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
// MARK: Set Targets
extension ModifyProfileViewController {
    func setTarget() {
        self.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goAlbumImageDidTap)))
        self.cameraButton.addTarget(self, action: #selector(goAlbumButtonDidTap), for: .touchUpInside)
        self.nameTextField.addTarget(self, action: #selector(nameTextFieldEditingChanged(_:)), for: .editingChanged)
        self.completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
        self.completeKeyboardButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }
    @objc func nameTextFieldEditingChanged(_ sender: UITextField) {
        self.isNicknameChanged = true
        let text = sender.text ?? ""
        self.nickname = text
        isNicknameValid(nickname: self.nickname!)
    }
    // 닉네임 유효성 검사
    func isNicknameValid(nickname: String) {
        self.completeButton.isActivate = nickname == "" ? false : true
        self.completeKeyboardButton.isActivate = nickname == "" ? false : true
    }
    // 앨범에서 사진/동영상 선택
    // 프로필 이미지 클릭 시
    @objc func goAlbumImageDidTap(sender: UITapGestureRecognizer) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
        UIDevice.vibrate()
    }
    // 카메라 클릭 시
    @objc func goAlbumButtonDidTap() {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
        UIDevice.vibrate()
    }
    @objc func completeButtonDidTap() {
        UIDevice.vibrate()
        
        var lottieView = self.completeButton.setLottieView()
        self.completeButton.isSelected = true
        
        lottieView = self.completeKeyboardButton.setLottieView()
        self.completeKeyboardButton.isSelected = true
        
        lottieView.isHidden = false
        
        lottieView.play { completion in
            lottieView.loopMode = .loop
            DispatchQueue.main.async {
                if self.isPhotoSelected && self.isNicknameChanged {
                    ModifyProfileDataManager().modifyProfileDataManager(self.nickname!, self.selectedPhoto, self)
                } else if self.isNicknameChanged {
                    let modifyProfileInput = ModifyProfileInputNickname(nickname: self.nickname)
                    ModifyProfileDataManager().modifyProfileDataManager(modifyProfileInput, self)
                } else if self.isPhotoSelected {
                    ModifyProfileDataManager().modifyProfileDataManager(self.selectedPhoto, self)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
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
    func modifyProfileAPISuccess(_ result: APIModel<TokenResultModel>) {
        if result.success {
            self.modified = true
            self.navigationController?.popViewController(animated: true)
        } else {}
        
        print(result.message)
    }
}
