//
//  ShoppingLinkViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/15.
//

import UIKit
import Lottie

class ShoppingLinkViewController: BottomSheetKeyboardViewController {
    let titleLabel = UILabel().then{
        $0.text = "쇼핑몰 링크"
        $0.font = UIFont.Suit(size: 14, family: .Bold)
    }
    let exitBtn = UIButton().then{
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    let shoppingLinkTextField = UITextField().then{
        $0.addLeftPadding(10)
        $0.backgroundColor = .wishboardTextfieldGray
        $0.layer.cornerRadius = 5
        $0.font = UIFont.Suit(size: 16, family: .Regular)
        $0.textColor = .editTextFontColor
        $0.clearButtonMode = .always
        $0.placeholder = "쇼핑몰 링크"
    }
    let errorMessage = UILabel().then{
        $0.text = "쇼핑몰 링크를 다시 확인해 주세요."
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textColor = .wishboardRed
        $0.setTextWithLineHeight()
    }
    let completeButton = UIButton().then{
        $0.defaultButton("아이템 불러오기", .wishboardGreen, .black)
    }
    // MARK: - Life Cycles
    var preVC: UploadItemViewController!
    var link: String!
    var tempLink: String!
    var isExit: Bool = true
    var isFail: Bool = false
    
    var itemImgUrl: String?
    var itemName: String?
    var itemPrice: String?
    
    var lottieView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.textfield = self.shoppingLinkTextField
        super.backBtn.isHidden = true
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.view.roundCornersDiffernt(topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0)

        setUpView()
        setUpConstraint()
        
        self.errorMessage.isHidden = true
        self.completeButton.isEnabled = false
        self.completeButton.defaultButton("아이템 불러오기", .wishboardDisabledGray, .dialogMessageColor)
        
        self.shoppingLinkTextField.addTarget(self, action: #selector(LinkTextFieldEditingChanged(_:)), for: .editingChanged)
        self.exitBtn.addTarget(self, action: #selector(exit), for: .touchUpInside)
        self.completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }
    override func viewWillDisappear(_ animated: Bool) {
        if !isExit && !isFail {
            self.preVC.wishListData.item_img_url = self.itemImgUrl
            self.preVC.wishListData.item_name = self.itemName
            self.preVC.wishListData.item_price = self.itemPrice
            self.preVC.wishListData.item_url = self.link
            self.preVC.selectedImage = nil
            self.preVC.isValidContent()
            
            let indexPath1 = IndexPath(row: 0, section: 0)
            let indexPath2 = IndexPath(row: 1, section: 0)
            let indexPath5 = IndexPath(row: 4, section: 0)
            self.preVC.uploadItemView.uploadImageTableView.reloadData()
            self.preVC.uploadItemView.uploadContentTableView.reloadRows(at: [indexPath1, indexPath2, indexPath5], with: .automatic)
            self.preVC.isValidContent()
            
            self.preVC.view.endEditing(true)
            self.preVC.view.frame.origin.y = 0.0
            self.preVC.preKeyboardHeight = 0.0
        } else if isFail {
            self.preVC.wishListData.item_img_url = nil
            self.preVC.wishListData.item_name = nil
            self.preVC.wishListData.item_price = nil
            self.preVC.wishListData.item_url = ""
            self.preVC.isValidContent()
            
            let indexPath1 = IndexPath(row: 0, section: 0)
            let indexPath2 = IndexPath(row: 1, section: 0)
            let indexPath5 = IndexPath(row: 4, section: 0)
            self.preVC.uploadItemView.uploadImageTableView.reloadRows(at: [indexPath1], with: .automatic)
            self.preVC.uploadItemView.uploadContentTableView.reloadRows(at: [indexPath1, indexPath2, indexPath5], with: .automatic)
            self.preVC.isValidContent()
            
            SnackBar(self.preVC, message: .failShoppingLink)
            self.preVC.view.endEditing(true)
            self.preVC.view.frame.origin.y = 0.0
            self.preVC.preKeyboardHeight = 0.0
        }
        else {
            self.preVC.view.endEditing(true)
            self.preVC.view.frame.origin.y = 0.0
            self.preVC.preKeyboardHeight = 0.0
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    // MARK: - Functions
    func setPreViewController(_ preVC: UploadItemViewController) {
        self.preVC = preVC
    }
    func setUpView() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(exitBtn)
        self.view.addSubview(shoppingLinkTextField)
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
        shoppingLinkTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(82)
            make.height.equalTo(42)
        }
        errorMessage.snp.makeConstraints { make in
            make.leading.equalTo(shoppingLinkTextField)
            make.top.equalTo(shoppingLinkTextField.snp.bottom).offset(6)
        }
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(shoppingLinkTextField.snp.bottom).offset(86)
        }
    }
    // MARK: - Actions
    @objc func exit() {
        UIDevice.vibrate()
        self.isExit = true
        self.dismiss(animated: true)
    }
    @objc func completeButtonDidTap() {
        UIDevice.vibrate()
        lottieView = self.completeButton.setHorizontalLottieView(self.completeButton)
        self.completeButton.isSelected = true
        lottieView.isHidden = false
        lottieView.play { completion in
            ItemDataManager().getItemByLinkDataManager(self.link, self)
        }
    }
    @objc func LinkTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        let trimString = text.trimmingCharacters(in: .whitespaces)
        self.tempLink = trimString
        self.shoppingLinkTextField.text = self.tempLink
        self.checkLink(self.tempLink)
    }
    func checkLink(_ link: String) {
        if !verifyURL(url: link) {
            if link == "" {self.errorMessage.isHidden = true}
            else {
                self.errorMessage.isHidden = false
                self.completeButton.defaultButton("아이템 불러오기", .wishboardDisabledGray, .dialogMessageColor)
                self.completeButton.isEnabled = false
            }
        } else {
            self.errorMessage.isHidden = true
            self.completeButton.defaultButton("아이템 불러오기", .wishboardGreen, .black)
            self.completeButton.isEnabled = true
            self.link = self.tempLink
        }
    }
    // url 유효성 검사
    func verifyURL(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        if urlTest.evaluate(with: url) {
            return true
        }

        let range = NSRange(location: 0, length: url.utf16.count)
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue),
            let match: NSTextCheckingResult = detector.firstMatch(in: url, options: [], range: range) else {
            return false
        }

        return match.range.length == url.utf16.count
    }
}
// MARK: - API Success
extension ShoppingLinkViewController {
    // MARK: 아이템 불러오기 API
    func getItemByLinkAPISuccess(_ result: APIModel<ItemParsingModel>) {
        if let imageUrl = result.data?.item_img {
            self.itemImgUrl = imageUrl
        } else {self.itemImgUrl = nil}
        if let itemName = result.data?.item_name {
            self.itemName = itemName
        } else {self.itemName = nil}
        if let itemPrice = result.data?.item_price {
            self.itemPrice = itemPrice
        } else {self.itemPrice = "0"}
        self.viewDidLoad()
        self.isExit = false
        self.isFail = false
        self.lottieView.isHidden = true
        self.completeButton.isSelected = false
        
        print("parsing::", result)
        self.dismiss(animated: true)
    }
    func getItemByLinkAPIFail() {
        self.isFail = true
        
        self.errorMessage.isHidden = false
        self.completeButton.isSelected = false
        self.completeButton.defaultButton("아이템 불러오기", .wishboardDisabledGray, .dialogMessageColor)
        self.completeButton.isEnabled = false
        self.lottieView.isHidden = true
        
        self.dismiss(animated: true)
    }
    func getItemByLinkAPIFail429() {
        ItemDataManager().getItemByLinkDataManager(self.link, self)
    }
}
