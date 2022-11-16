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
        $0.clearButtonMode = .always
        $0.textColor = .editTextFontColor
    }
    let errorMessageLabel = UILabel().then{
        $0.text = "동일이름의 폴더가 있어요!"
        $0.textColor = .wishboardRed
        $0.font = UIFont.Suit(size: 12, family: .Regular)
    }
    var completeButton: UIButton!
    // MARK: - Life Cycles
    // keyboard
    var restoreFrameValue: CGFloat = 0.0
    
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
            $0.defaultButton(self.buttonTitle!, .wishboardDisabledGray, .dialogMessageColor)
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
        
        errorMessageLabel.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.popupView.transform = .identity
            self?.popupView.isHidden = false
        }
        self.addKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.popupView.transform = .identity
            self?.popupView.isHidden = true
        }
        self.removeKeyboardNotifications()
    }
    // MARK: - Actions
    @objc func goBack() {
        self.dismiss(animated: false)
    }
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        let textLength = text.count
        self.countLabel.text = "(" + String(textLength) + "/10)자"
        
        if textLength > 10 {
            completeButton.defaultButton(self.buttonTitle!, .wishboardDisabledGray, .dialogMessageColor)
            self.countLabel.textColor = .wishboardRed
            completeButton.isEnabled = false
        } else if textLength == 0 {
            completeButton.defaultButton(self.buttonTitle!, .wishboardDisabledGray, .dialogMessageColor)
            self.countLabel.textColor = .wishboardGray
            completeButton.isEnabled = false
        } else {
            completeButton.defaultButton(self.buttonTitle!, .wishboardGreen, .black)
            self.countLabel.textColor = .wishboardGray
            completeButton.isEnabled = true
        }
        errorMessageLabel.isHidden = true
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
        popupView.addSubview(errorMessageLabel)
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
        errorMessageLabel.snp.makeConstraints { make in
            make.leading.equalTo(textField)
            make.top.equalTo(textField.snp.bottom).offset(6)
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

    func completeButtonDidTap() {
        completeButton.isEnabled = false
        completeButton.defaultButton("", .wishboardGreen, .black)
    }
    func sameFolderNameFail() {
        errorMessageLabel.isHidden = false
        completeButton.defaultButton(self.buttonTitle!, .wishboardDisabledGray, .dialogMessageColor)
        completeButton.isEnabled = false
    }
}
// MARK: - TextField & Keyboard Methods
extension PopUpWithTextFieldViewController: UITextFieldDelegate {
    func addKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillAppear(noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let viewHeight = self.popupView.frame.origin.y
            let dif = keyboardHeight - viewHeight
            self.view.frame.origin.y -= (dif + 10)
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
