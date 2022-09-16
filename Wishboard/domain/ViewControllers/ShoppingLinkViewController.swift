//
//  ShoppingLinkViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/15.
//

import UIKit

class ShoppingLinkViewController: UIViewController {
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
        $0.textColor = .wishboardGray
        $0.clearButtonMode = .whileEditing
        $0.placeholder = "쇼핑몰 링크"
    }
    let errorMessage = UILabel().then{
        $0.text = "쇼핑몰 링크를 다시 확인해 주세요."
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textColor = .wishboardRed
    }
    let completeButton = UIButton().then{
        $0.defaultButton("아이템 불러오기", .wishboardGreen, .black)
    }
    // MARK: - Life Cycles
    var link: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.view.roundCornersDiffernt(topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0)

        setUpView()
        setUpConstraint()
        
        self.errorMessage.isHidden = true
        self.completeButton.isEnabled = false
        
        self.shoppingLinkTextField.addTarget(self, action: #selector(LinkTextFieldEditingChanged(_:)), for: .editingChanged)
        self.exitBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    // MARK: - Functions
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
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    @objc func LinkTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text
        let trimString = text!.trimmingCharacters(in: .whitespaces)
        self.link = trimString
        self.shoppingLinkTextField.text = self.link
        self.checkLink(self.link)
    }
    func checkURL(str: String) -> Bool {
        let regex = "/(http|https):\\/\\/(\\w+:{0,1}\\w*@)?(\\S+)(:[0-9]+)?(\\/|\\/([\\w#!:.?+=&%@!\\-\\/]))?/"
        return  NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
    }
    func checkLink(_ link: String) {
        if !checkURL(str: link) {
            self.errorMessage.isHidden = false
            self.completeButton.defaultButton("아이템 불러오기", .wishboardDisabledGray, .gray)
        } else {
            self.errorMessage.isHidden = true
            self.completeButton.defaultButton("아이템 불러오기", .wishboardGreen, .black)
        }
    }
}
