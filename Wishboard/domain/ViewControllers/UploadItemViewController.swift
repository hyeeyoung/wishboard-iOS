//
//  UploadItemViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/15.
//

import UIKit
import MaterialComponents.MaterialBottomSheet

class UploadItemViewController: UIViewController {
    // MARK: - Properties
    var uploadItemView: UploadItemView!
    let cellTitleArray = ["상품명(필수)", "₩ 가격(필수)", "폴더", "상품 일정 알림", "쇼핑몰 링크", "브랜드, 사이즈, 컬러 등 아이템 정보를 메모로 남겨보세요!😉"]
    var selectedImage: UIImage!
    
    var foldervc: SetFolderBottomSheetViewController!
    var notivc: NotificationSettingViewController!
    var linkvc: ShoppingLinkViewController!
    
    var itemName: String!
    var itemPrice: String!
    var notiType: String!
    var notiDate: String!
    var memo: String!
    
    var isUploadItem: Bool!
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        setUploadItemView()
    }
    @objc func clickEvent() {
        print("clicked!")
    }
    @objc func goBack() {
        self.dismiss(animated: true)
    }
}
// MARK: - TableView delegate
extension UploadItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        // 사진 선택 Cell
        if tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UploadItemPhotoTableViewCell", for: indexPath) as? UploadItemPhotoTableViewCell else { return UITableViewCell() }
            if let photo = self.selectedImage {
                cell.photoImage.image = photo
                cell.cameraImage.isHidden = true
            }
            
            return cell
        } else {
            let cell = UITableViewCell()
            // TextField가 있는 Cell
            if tag == 1 || tag == 2 || tag == 6 {setTextFieldCell(cell, tag)}
            // 클릭 시 bottomSheet 올라오는 Cell
            if tag == 3 || tag == 4 || tag == 5 {setSelectCell(cell, tag)}
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tag = indexPath.row
        switch tag {
        case 0:
            return 251
        default:
            return 54
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = indexPath.row
        switch tag {
        // '사진 찍기' '사진 보관함' 팝업창
        case 0:
            alertCameraMenu()
        // 폴더 설정 BottomSheet
        case 3:
            showFolderBottomSheet()
        // 알람 설정 BottomSheet
        case 4:
            showNotificationBottomSheet()
        // 쇼핑몰 링크 BottomSheet
        case 5:
            showLinkBottomSheet()
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - Functions
extension UploadItemViewController {
    func setUploadItemView() {
        uploadItemView = UploadItemView()
        uploadItemView.setTableView(dataSourceDelegate: self)
        uploadItemView.setUpView()
        uploadItemView.setUpConstraint()
        
        self.view.addSubview(uploadItemView)
        uploadItemView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        uploadItemView.saveButton.addTarget(self, action: #selector(clickEvent), for: .touchUpInside)
        uploadItemView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        if isUploadItem {
            uploadItemView.backButton.isHidden = true
            uploadItemView.pageTitle.text = "아이템 추가"
            uploadItemView.setSaveButton(false)
        } else {
            uploadItemView.backButton.isHidden = false
            uploadItemView.pageTitle.text = "아이템 수정"
            uploadItemView.setSaveButton(true)
        }
        // BottomSheet 객체 선언
        foldervc =  SetFolderBottomSheetViewController()
        linkvc = ShoppingLinkViewController()
        notivc = NotificationSettingViewController()
    }
}
// MARK: - Cell set & Actions
extension UploadItemViewController {
    // 클릭 시 bottomSheet 올라오는 Cell
    func setSelectCell(_ cell: UITableViewCell, _ tag: Int) {
        cell.textLabel?.text = cellTitleArray[tag - 1]
        cell.textLabel?.font = UIFont.Suit(size: 14, family: .Regular)
        let arrowImg = UIImageView().then{
            $0.image = UIImage(named: "arrow_right")
        }
        let subTitle = UILabel().then{
            $0.text = "복사한 링크로 아이템 정보를 불러올 수 있어요!"
            $0.font = UIFont.Suit(size: 10, family: .Regular)
            $0.textColor = .wishboardGreen
        }
        cell.contentView.addSubview(arrowImg)
        if tag == 5 {cell.contentView.addSubview(subTitle)}
        
        arrowImg.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        if tag == 5 {
            subTitle.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(arrowImg.snp.leading)
            }
        }
        
        guard let type = notivc.notiType else {return}
        guard let dateTime = notivc.dateAndTime else {return}
        if tag == 4 {cell.textLabel?.text = "[" + type + "] " + dateTime}
    }
    // TextField가 있는 Cell
    func setTextFieldCell(_ cell: UITableViewCell, _ tag: Int) {
        let textfield = UITextField().then{
            $0.backgroundColor = .clear
            $0.placeholder = self.cellTitleArray[tag - 1]
            $0.font = UIFont.Suit(size: 14, family: .Regular)
            $0.addLeftPadding(16)
        }
        cell.contentView.addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
        // Add target
        switch tag {
        case 1:
            textfield.addTarget(self, action: #selector(itemNameTextfieldEditingField(_:)), for: .editingChanged)
        case 2:
            textfield.addTarget(self, action: #selector(itemPriceTextfieldEditingField(_:)), for: .editingChanged)
        default:
            textfield.addTarget(self, action: #selector(memoTextfieldEditingField(_:)), for: .editingChanged)
        }
        
    }
    // Actions
    @objc func itemNameTextfieldEditingField(_ sender: UITextField) {
        let text = sender.text!
        self.itemName = text
        isValidContent()
    }
    @objc func itemPriceTextfieldEditingField(_ sender: UITextField) {
        let text = sender.text!
        self.itemPrice = text
        isValidContent()
    }
    @objc func memoTextfieldEditingField(_ sender: UITextField) {
        let text = sender.text!
        self.memo = text
    }
    // 상품명, 가격 입력 여부에 따른 저장버튼 활성화 설정
    func isValidContent() {
        guard let iN = self.itemName else {return}
        guard let iP = self.itemPrice else {return}
        guard let iI = self.selectedImage else {return}
        
        if (iN != "") && (iP != "") {uploadItemView.setSaveButton(true)}
        else {uploadItemView.setSaveButton(false)}
    }
    // '사진 찍기' '사진 보관함' 팝업창
    func alertCameraMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cameraAction =  UIAlertAction(title: "사진 찍기", style: UIAlertAction.Style.default){(_) in
            let camera = UIImagePickerController()
            camera.sourceType = .camera
            camera.allowsEditing = true
            camera.cameraDevice = .rear
            camera.cameraCaptureMode = .photo
            camera.delegate = self
            self.present(camera, animated: true, completion: nil)
        }
        let albumAction =  UIAlertAction(title: "사진 보관함", style: UIAlertAction.Style.default){(_) in
            let album = UIImagePickerController()
            album.delegate = self
            album.sourceType = .photoLibrary
            self.present(album, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.view.tintColor = .black
        alert.addAction(cameraAction)
        alert.addAction(albumAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }
    // 폴더 설정 BottomSheet
    func showFolderBottomSheet() {
        foldervc = SetFolderBottomSheetViewController()
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: foldervc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 317
        bottomSheet.dismissOnDraggingDownSheet = false
        
        self.present(bottomSheet, animated: true, completion: nil)
    }
    // 알람 설정 BottomSheet
    func showNotificationBottomSheet() {
        notivc.setPreViewController(self)
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: notivc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 317
        bottomSheet.dismissOnDraggingDownSheet = false
        
        self.present(bottomSheet, animated: true, completion: nil)
    }
    // 쇼핑몰 링크 BottomSheet
    func showLinkBottomSheet() {
        linkvc = ShoppingLinkViewController()
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: linkvc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 317
        bottomSheet.dismissOnDraggingDownSheet = false
        
        self.present(bottomSheet, animated: true, completion: nil)
    }
}
// MARK: - ImagePicker Delegate
extension UploadItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
//            self.selectedImage = image
//            self.uploadItemView.uploadItemTableView.reloadData()
//        }
        // 앨범에서 사진 선택 시
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImage = image
            isValidContent()
            
            // 첫번째 셀만 reload
            let indexPath = IndexPath(row: 0, section: 0)
            self.uploadItemView.uploadItemTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
