//
//  ShoppingLinkViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/15.
//

import UIKit
import Lottie

class ShoppingLinkViewController: BottomSheetKeyboardViewController {
//    let titleLabel = DefaultLabel().then{
//        $0.text = BottomSheetTitle.shoppingMallLink
//        $0.setTypoStyleWithSingleLine(typoStyle: .SuitH3)
//    }
//    let exitBtn = UIButton().then{
//        $0.setImage(Image.quit, for: .normal)
//    }
//    let shoppingLinkTextField = DefaultTextField(Placeholder.shoppingLink).then{
//        $0.clearButtonMode = .always
//    }
//    let errorMessage = UILabel().then{
//        $0.text = ErrorMessage.shoppingLink
//        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
//        $0.textColor = .pink_700
//    }
//    let completeButton = DefaultButton(titleStr: Button.item).then{
//        $0.isActivate = true
//    }
    // MARK: - Life Cycles
    var preVC: UploadItemViewController!
    var link: String!
    var tempLink: String!
    var isExit: Bool = true
    var isFail: Bool = false
    
    var itemImgUrl: String?
    var itemName: String?
    var itemPrice: String?
    
    var lottieView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if !isExit && !isFail {
            preVC.wishListData.item_img_url = self.itemImgUrl
            preVC.wishListData.item_name = self.itemName
            preVC.wishListData.item_price = self.itemPrice
            preVC.wishListData.item_url = self.link
            preVC.selectedImage = nil
            preVC.isValidContent()
            
            let indexPath1 = IndexPath(row: 0, section: 0)
            let indexPath2 = IndexPath(row: 1, section: 0)
            let indexPath5 = IndexPath(row: 4, section: 0)
            preVC.uploadItemView.uploadImageTableView.reloadData()
            preVC.uploadItemView.uploadContentTableView.reloadRows(at: [indexPath1, indexPath2, indexPath5], with: .automatic)
            preVC.isValidContent()
            
            preVC.view.endEditing(true)
            preVC.view.frame.origin.y = 0.0
            preVC.preKeyboardHeight = 0.0
        } else if isFail {
            preVC.wishListData.item_img_url = nil
            preVC.wishListData.item_name = nil
            preVC.wishListData.item_price = nil
            preVC.wishListData.item_url = ""
            preVC.isValidContent()
            
            let indexPath1 = IndexPath(row: 0, section: 0)
            let indexPath2 = IndexPath(row: 1, section: 0)
            let indexPath5 = IndexPath(row: 4, section: 0)
            preVC.uploadItemView.uploadImageTableView.reloadRows(at: [indexPath1], with: .automatic)
            preVC.uploadItemView.uploadContentTableView.reloadRows(at: [indexPath1, indexPath2, indexPath5], with: .automatic)
            preVC.isValidContent()
            
            SnackBar(self.preVC, message: .failShoppingLink)
            preVC.view.endEditing(true)
            preVC.view.frame.origin.y = 0.0
            preVC.preKeyboardHeight = 0.0
        }
        else {
            preVC.view.endEditing(true)
            preVC.view.frame.origin.y = 0.0
            preVC.preKeyboardHeight = 0.0
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    // MARK: - Functions
    override func initComponents() {
        // bottom sheet title
        titleLabel.text = BottomSheetTitle.shoppingMallLink
        
        // textfield placeholder
        textfield = DefaultTextField(Placeholder.shoppingLink).then{
            $0.clearButtonMode = .always
        }
        
        // textfield count label
        textFieldCountLabel.isHidden = true
        
        // error message text
        errorMessage.text = ErrorMessage.shoppingLink
        errorMessage.isHidden = true
        
        // complete button
        completeButton = DefaultButton(titleStr: Button.add).then{
            $0.isActivate = false
        }
    }
    func setPreViewController(_ preVC: UploadItemViewController) {
        self.preVC = preVC
    }
    
    // MARK: - Actions
    @objc override func exit() {
        UIDevice.vibrate()
        self.isExit = true
        self.dismiss(animated: true)
    }
    @objc override func completeButtonDidTap() {
        UIDevice.vibrate()
        lottieView = self.completeButton.setLottieView()
        lottieView.play { completion in
            ItemDataManager().getItemByLinkDataManager(self.link, self)
        }
    }
    @objc override func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        let trimString = text.trimmingCharacters(in: .whitespaces)
        self.tempLink = trimString
        self.textfield.text = self.tempLink
        self.checkLink(self.tempLink)
    }
    func checkLink(_ link: String) {
        if !verifyURL(url: link) {
            if link == "" {self.errorMessage.isHidden = true}
            else {
                self.errorMessage.isHidden = false
                self.completeButton.isActivate = false
            }
        } else {
            self.errorMessage.isHidden = true
            self.completeButton.isActivate = true
            self.link = self.tempLink
        }
    }
    // url 유효성 검사
    func verifyURL(url: String) -> Bool {
        let urlRegEx = RegularExpression.shoppingLink
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
        self.completeButton.then{
            $0.isActivate = false
            $0.inActivateLottieView()
        }
        
        self.dismiss(animated: true)
    }
    func getItemByLinkAPIFail429() {
        
//        ItemDataManager().getItemByLinkDataManager(self.link, self)
    }
}
