//
//  ShoppingLinkViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/15.
//

import UIKit
import Lottie

class ShoppingLinkViewController: BottomSheetKeyboardViewController {
    var observer = ItemLinkObserver.shared
    
    // MARK: - Life Cycles
    var link: String!
    var tempLink: String!
    
    var itemImgUrl: String?
    var itemName: String?
    var itemPrice: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        completeButton = LoadingButton(Button.add).then{
            $0.inactivateButton()
        }
    }
    
    // MARK: - Actions
    @objc override func exit() {
        UIDevice.vibrate()
        observer.notify(ItemParseData(itemModel: nil, usecase: .itemLinkExit))
        self.dismiss(animated: true)
    }
    @objc override func completeButtonDidTap() {
        UIDevice.vibrate()
        
        completeButton.startLoadingAnimation()
        ItemDataManager().getItemByLinkDataManager(self.link, self)
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
                self.completeButton.inactivateButton()
            }
        } else {
            self.errorMessage.isHidden = true
            self.completeButton.activateButton()
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
        if let itemPrice = result.data?.item_price.nilIfEmpty {
            self.itemPrice = itemPrice
        } else {self.itemPrice = "0"}
        self.viewDidLoad()
        
        print("parsing::", result)
        let model = ItemParseModel(link: self.link, imageURL: self.itemImgUrl, itemName: self.itemName, itemPrice: self.itemPrice)
        observer.notify(ItemParseData(itemModel: model, usecase: .itemParsingSuccess))
        self.dismiss(animated: true)
    }
    func getItemByLinkAPIFail() {
        observer.notify(ItemParseData(itemModel: nil, usecase: .itemParsingFail))
        
        self.errorMessage.isHidden = false
        self.completeButton.then{
            $0.inactivateButton()
        }
        
        self.dismiss(animated: true)
    }
    func getItemByLinkAPIFail429() {
//        ItemDataManager().getItemByLinkDataManager(self.link, self)
    }
}
