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
    var numberFormatter: NumberFormatter!
    var selectedImage: UIImage!
    // Bottom Sheets
    var foldervc: SetFolderBottomSheetViewController!
    var notivc: NotificationSettingViewController!
    var linkvc: ShoppingLinkViewController!
    // Modify Item
    var isUploadItem: Bool!
    var wishListModifyData: WishListModel!
    // UploadItem
    var wishListData: WishListModel!
    // keyboard
    var restoreFrameValue: CGFloat = 0.0
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        // keyboard
        self.restoreFrameValue = self.view.frame.origin.y
        
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        setUploadItemView()
        
        if !isUploadItem {
            self.wishListData = self.wishListModifyData
        } else {
            self.wishListData = WishListModel(folder_id: nil, folder_name: nil, item_id: nil, item_img_url: nil, item_name: nil, item_price: nil, item_url: "", item_memo: "", create_at: nil, item_notification_type: nil, item_notification_date: nil, cart_state: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
            
            // 만약 아이템 수정이라면 기존 이미지 출력
            if !isUploadItem {
                if let itemImageURL = self.wishListData.item_img_url {
                    cell.setUpImage(itemImageURL)
                }
            } else {    // 만약 새로 아이템을 추가하는 경우라면
                cell.photoImage.image = UIImage()
                cell.cameraImage.isHidden = false
            }
            // 새로 사진을 선택했다면
            if self.selectedImage != nil {
                cell.setUpImage(self.selectedImage)
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
        uploadItemView.uploadItemTableView.keyboardDismissMode = .onDrag
        uploadItemView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        if isUploadItem {
            uploadItemView.backButton.isHidden = true
            uploadItemView.pageTitle.text = "아이템 추가"
            uploadItemView.saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
            uploadItemView.setSaveButton(false)
        } else {
            uploadItemView.backButton.isHidden = false
            uploadItemView.pageTitle.text = "아이템 수정"
            uploadItemView.saveButton.addTarget(self, action: #selector(modifyButtonDidTap), for: .touchUpInside)
            uploadItemView.setSaveButton(true)
        }
        // BottomSheet 객체 선언
        foldervc =  SetFolderBottomSheetViewController()
        linkvc = ShoppingLinkViewController()
        notivc = NotificationSettingViewController()
    }
    // MARK: - 저장 버튼 클릭 시 (아이템 추가)
    @objc func saveButtonDidTap() {
        let lottieView = uploadItemView.saveButton.setSpinLottieView(uploadItemView.saveButton)
        uploadItemView.saveButton.isSelected = true
        lottieView.isHidden = false
        lottieView.play { completion in
            let data = self.wishListData
            if let folderId = data?.folder_id {
                // 모든 데이터가 존재하는 경우
                if let notiType = data?.item_notification_type {
                    ItemDataManager().uploadItemDataManager(folderId, self.selectedImage, (data?.item_name)!, (data?.item_price)!, (data?.item_url)!, (data?.item_memo)!, notiType, (data?.item_notification_date)!, self)
                } else {
                    // 알림 날짜 설정은 하지 않은 경우
                    ItemDataManager().uploadItemDataManager(folderId, self.selectedImage, (data?.item_name)!, (data?.item_price)!, (data?.item_url)!, (data?.item_memo)!, self)
                }
            } else {
                // 일부 데이터가 존재하는 경우
                ItemDataManager().uploadItemDataManager(self.selectedImage, (data?.item_name)!, (data?.item_price)!, (data?.item_url)!, (data?.item_memo)!, self)
            }
        }
    }
    // MARK: 저장 버튼 클릭 시 (아이템 수정)
    @objc func modifyButtonDidTap() {
        let lottieView = uploadItemView.saveButton.setSpinLottieView(uploadItemView.saveButton)
        uploadItemView.saveButton.isSelected = true
        lottieView.isHidden = false
        lottieView.play { completion in
            let data = self.wishListData
            DispatchQueue.main.async {
                // 이미지 uri를 UIImage로 변환
                let url = URL(string: (data?.item_img_url!)!)
                let imgData = try? Data(contentsOf: url!)
                var selectedImage : UIImage?
                if self.selectedImage == nil {selectedImage = UIImage(data: imgData!)}
                else {selectedImage = self.selectedImage}
                
                if let folderId = data?.folder_id {
                    // 모든 데이터가 존재하는 경우
                    if let notiType = data?.item_notification_type {
                        ItemDataManager().modifyItemDataManager(folderId, selectedImage!, (data?.item_name)!, (data?.item_price)!, (data?.item_url)!, (data?.item_memo)!, notiType, (data?.item_notification_date)!, (data?.item_id)!, self)
                    } else {
                        // 알림 날짜 설정은 하지 않은 경우
                        ItemDataManager().modifyItemDataManager(folderId, selectedImage!, (data?.item_name)!, (data?.item_price)!, (data?.item_url)!, (data?.item_memo)!, (data?.item_id)!, self)
                    }
                } else {
                    // 일부 데이터가 존재하는 경우
                    ItemDataManager().modifyItemDataManager(selectedImage!, (data?.item_name)!, (data?.item_price)!, (data?.item_url)!, (data?.item_memo)!, (data?.item_id)!, self)
                }
            }
        }
    }
}
// MARK: - Cell set & Actions
extension UploadItemViewController {
    // 클릭 시 bottomSheet 올라오는 Cell
    func setSelectCell(_ cell: UITableViewCell, _ tag: Int) {
        // 만약 아이템 수정이라면
        if !isUploadItem {
            switch tag {
            case 3:
                if let folder = self.wishListData.folder_name {cell.textLabel?.text = folder}
                else {cell.textLabel?.text = cellTitleArray[tag - 1]}
            case 4:
                if let notiType = self.wishListData.item_notification_type {
                    if let notiDate = self.wishListData.item_notification_date {
                        cell.textLabel?.text = "[" + notiType + "] " + notiDate
                    }
                }
                else {cell.textLabel?.text = cellTitleArray[tag - 1]}
            case 5:
                if let link = self.wishListData.item_url {
                    if link != "" {cell.textLabel?.text = link}
                    else {cell.textLabel?.text = cellTitleArray[tag - 1]}
                }
                else {cell.textLabel?.text = cellTitleArray[tag - 1]}
            default:
                fatalError()
            }
        } else {
            // 새로 아이템 추가하는 경우라면 placeHolder 초기설정
            cell.textLabel?.text = cellTitleArray[tag - 1]
        }
        cell.textLabel?.font = UIFont.Suit(size: 14, family: .Regular)
        
        let arrowImg = UIImageView().then{
            $0.image = UIImage(named: "arrow_right")
        }
        cell.contentView.addSubview(arrowImg)
        arrowImg.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        // 쇼핑몰 링크 입력 셀
        if tag == 5 {
            let subTitle = UILabel().then{
                $0.text = "복사한 링크로 아이템 정보를 불러올 수 있어요!"
                $0.font = UIFont.Suit(size: 10, family: .Regular)
                $0.textColor = .wishboardGreen
            }
            cell.contentView.addSubview(subTitle)
            subTitle.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(arrowImg.snp.leading)
            }
            if !isUploadItem {subTitle.isHidden = true}
            // 만약 쇼핑몰 링크를 수정했다면 업데이트
            if let link = linkvc.link {
                cell.textLabel?.text = link
                subTitle.isHidden = true
            }
        }
        // 만약 알림 날짜를 재설정했다면 업데이트
        if let type = notivc.notiType {
            if let dateTime = notivc.dateAndTime {
                if tag == 4 {cell.textLabel?.text = "[" + type + "] " + dateTime}
                self.wishListData.item_notification_type = type
                self.wishListData.item_notification_date = FormatManager().koreanStrToDate(dateTime)
            }
        }
        // 만약 폴더를 재선택했다면 업데이트
        if let selectedFolder = foldervc.selectedFolder {
            if tag == 3 {cell.textLabel?.text = selectedFolder}
        }
    }
    // TextField가 있는 Cell
    func setTextFieldCell(_ cell: UITableViewCell, _ tag: Int) {
        let textfield = UITextField().then{
            $0.backgroundColor = .clear
            $0.placeholder = self.cellTitleArray[tag - 1]
            $0.font = UIFont.Suit(size: 14, family: .Regular)
            $0.addLeftPadding(16)
            $0.delegate = self
        }
        cell.contentView.addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
        // Add target
        switch tag {
        case 1:
            if let itemName = self.wishListData.item_name {textfield.text = itemName}
            textfield.addTarget(self, action: #selector(itemNameTextfieldEditingField(_:)), for: .editingChanged)
        case 2:
            textfield.keyboardType = .numberPad
            if let price = self.wishListData.item_price {
                textfield.text = numberFormatter.string(from: NSNumber(value: Int(price)!))
            }
            textfield.addTarget(self, action: #selector(itemPriceTextfieldEditingField(_:)), for: .editingChanged)
        default:
            if let memo = self.wishListData.item_memo {textfield.text = memo}
            textfield.addTarget(self, action: #selector(memoTextfieldEditingField(_:)), for: .editingChanged)
        }
        
    }
    // Actions
    @objc func itemNameTextfieldEditingField(_ sender: UITextField) {
        let text = sender.text!
        self.wishListData.item_name = text
        isValidContent()
    }
    @objc func itemPriceTextfieldEditingField(_ sender: UITextField) {
        let text = sender.text ?? ""
        self.wishListData.item_price = setPriceString(text)
        guard let price = Float(text) else {return} //
        sender.text = numberFormatter.string(from: NSNumber(value: price))
        isValidContent()
    }
    @objc func memoTextfieldEditingField(_ sender: UITextField) {
        let text = sender.text!
        self.wishListData.item_memo = text
    }
    func setPriceString(_ str: String) -> String {
        let myString = str.replacingOccurrences(of: ",", with: "")
        return myString
    }
    // 상품명, 가격 입력 여부에 따른 저장버튼 활성화 설정
    func isValidContent() {
        guard let iN = self.wishListData.item_name else {return}
        guard let iP = self.wishListData.item_price else {return}
        guard let iI = self.selectedImage else {return}
        
        if (iN != "") && (iP != "") && (iI != nil) {uploadItemView.setSaveButton(true)}
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
        foldervc.setPreViewController(self)
        if !isUploadItem {
            foldervc.selectedFolderId = self.wishListData.folder_id
            foldervc.selectedFolder = self.wishListData.folder_name
        }
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
        linkvc.setPreViewController(self)
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: linkvc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 317
        bottomSheet.dismissOnDraggingDownSheet = false
        
        self.present(bottomSheet, animated: true, completion: nil)
    }
}
// MARK: - ImagePicker Delegate
extension UploadItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 앨범에서 사진 선택 시
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImage = image
            isValidContent()
            
            // 첫번째 셀만 reload
            let indexPath = IndexPath(row: 0, section: 0)
            self.uploadItemView.uploadItemTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        // 카메라에서 사진 찍은 경우
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.selectedImage = image
            isValidContent()
            
            // 첫번째 셀만 reload
            let indexPath = IndexPath(row: 0, section: 0)
            self.uploadItemView.uploadItemTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
// MARK: - API Success
extension UploadItemViewController {
    func uploadItemAPISuccess(_ result: APIModel<ResultModel>) {
        self.viewDidLoad()
        ScreenManager().goMainPages(0, self, family: .itemUpload)
        print(result.message)
    }
    func modifyItemAPISuccess(_ result: APIModel<ResultModel>) {
        self.viewDidLoad()
        ScreenManager().goMainPages(0, self, family: .itemModified)
        print(result.message)
    }
}
// MARK: - TextField & Keyboard Methods
extension UploadItemViewController: UITextFieldDelegate {
    
    @objc func keyboardWillAppear(noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y -= keyboardHeight
        }
        print("keyboard Will appear Execute")
    }
    
    @objc func keyboardWillDisappear(noti: NSNotification) {
        if self.view.frame.origin.y != restoreFrameValue {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y += keyboardHeight
            }
            print("keyboard Will Disappear Execute")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = restoreFrameValue
        print("touches Began Execute")
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn Execute")
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing Execute")
        self.view.frame.origin.y = self.restoreFrameValue
        return true
    }
    
}
