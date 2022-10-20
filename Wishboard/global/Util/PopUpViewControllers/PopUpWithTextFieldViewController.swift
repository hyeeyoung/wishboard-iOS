//
//  PopUpTextFieldViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/17.
//

import UIKit

class PopUpWithTextFieldViewController: UIViewController {
    // MARK: - Properties
    private var titleText: String?
    private var placeholder: String?
    private var prevText: String?
    private var buttonTitle: String?
    
    let popupView = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        
        $0.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    let titleLabel = UILabel().then{
        $0.text = "title"
        $0.font = UIFont.Suit(size: 16, family: .Bold)
    }
    let quitButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "x")
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    let countLabel = UILabel().then{
        $0.text = "(0/10)자"
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textColor = .wishboardGray
    }
    var textField = UITextField().then{
        $0.addLeftPadding(10)
        $0.backgroundColor = .wishboardTextfieldGray
        $0.layer.cornerRadius = 5
        $0.font = UIFont.Suit(size: 16, family: .Regular)
        $0.clearButtonMode = .whileEditing
        $0.textColor = .editTextFontColor
    }
    var completeButton: UIButton!
    // MARK: - Life Cycles
    convenience init(titleText: String? = nil,
                     placeholder: String? = nil,
                     prevText: String? = nil,
                     buttonTitle: String? = nil) {
        self.init()

        self.titleText = titleText
        self.placeholder = placeholder
        self.prevText = prevText
        self.buttonTitle = buttonTitle
        
        if let prevText = self.prevText {
            self.countLabel.text = "(" + String(prevText.count) + "/10)자"
        }
        completeButton = UIButton().then{
            $0.defaultButton(self.buttonTitle!, .wishboardDisabledGray, .gray)
            $0.isEnabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .popupBackground
        
        setUpContent()
        setUpView()
        setUpConstraint()
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        quitButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.popupView.transform = .identity
            self?.popupView.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.popupView.transform = .identity
            self?.popupView.isHidden = true
        }
    }
    // MARK: - Actions
    @objc func goBack() {
        self.dismiss(animated: false)
    }
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        let textLength = text.count
        self.countLabel.text = "(" + String(textLength) + "/10)자"
        
        if textLength > 10 || textLength == 0 {
            completeButton.defaultButton(self.buttonTitle!, .wishboardDisabledGray, .gray)
            self.countLabel.textColor = .wishboardRed
            completeButton.isEnabled = false
        } else {
            completeButton.defaultButton(self.buttonTitle!, .wishboardGreen, .black)
            self.countLabel.textColor = .wishboardGray
            completeButton.isEnabled = true
        }
    }
    // MARK: - Functions
    func setUpContent() {
        titleLabel.text = self.titleText
        textField.placeholder = self.placeholder
        guard let prevText = prevText else {return}
        textField.text = prevText

        completeButton.then{
            $0.defaultButton(self.buttonTitle!, .wishboardGreen, .black)
            $0.isEnabled = true
        }
    }
    func setUpView() {
        self.view.addSubview(popupView)
        
        popupView.addSubview(titleLabel)
        popupView.addSubview(quitButton)
        popupView.addSubview(countLabel)
        popupView.addSubview(textField)
        popupView.addSubview(completeButton)
    }
    func setUpConstraint() {
        popupView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(196)
            make.centerY.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        quitButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.trailing.equalToSuperview().offset(-6)
            make.centerY.equalTo(titleLabel)
        }
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        countLabel.snp.makeConstraints { make in
            make.trailing.equalTo(textField)
            make.top.equalTo(textField.snp.bottom).offset(6)
            make.bottom.equalTo(completeButton.snp.top).offset(-15)
        }
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.bottom.trailing.equalToSuperview().inset(16)
        }
    }

}
