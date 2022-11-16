//
//  PopUpTextfieldViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/15.
//

import UIKit

// 회원 탈퇴 창
class PopUpDeleteUserViewController: UIViewController {
    // MARK: - Properties
    private var titleText: String?
    private var messageText: String?
    private var greenBtnText: String?
    private var blackBtnText: String?
    private var placeholder: String?
    private var email: String?
    
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
    let messageLabel = UILabel().then{
        $0.text = "정말 탈퇴하시겠습니까?\n탈퇴 시 앱 내 모든 데이터가 사라집니다.\n서비스를 탈퇴하시려면 이메일을 입력해 주세요."
        $0.font = UIFont.Suit(size: 14, family: .Regular)
        $0.textColor = .dialogMessageColor
        $0.numberOfLines = 0
        
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.18
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
        
        $0.textAlignment = .center
    }
    let horizontalSeperator = UIView().then{
        $0.backgroundColor = .wishboardDisabledGray
    }
    let verticalSeperator = UIView().then{
        $0.backgroundColor = .wishboardDisabledGray
    }
    var cancelBtn: UIButton!
    var okBtn: UIButton!
    var textField = UITextField().then{
        $0.addLeftPadding(10)
        $0.backgroundColor = .wishboardTextfieldGray
        $0.layer.cornerRadius = 5
        $0.font = UIFont.Suit(size: 16, family: .Regular)
        $0.clearButtonMode = .always
        $0.textColor = .editTextFontColor
    }
    let errorMessage = UILabel().then{
        $0.text = "이메일을 다시 확인해 주세요."
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textColor = .wishboardRed
    }
    // MARK: - Life Cycles
    // keyboard
    var restoreFrameValue: CGFloat = 0.0
    
    convenience init(titleText: String? = nil,
                     greenBtnText: String? = nil,
                     blackBtnText: String? = nil,
                     placeholder: String? = nil,
                     email: String? = nil) {
        self.init()

        self.titleText = titleText
        self.greenBtnText = greenBtnText
        self.blackBtnText = blackBtnText
        self.placeholder = placeholder
        self.email = email
        
        setUpContent()
        setUpView()
        setUpConstraint()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .popupBackground
        self.errorMessage.isHidden = true
        
        cancelBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        textField.addTarget(self, action: #selector(emailTextFieldEditingChanged(_:)), for: .editingChanged)
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
    @objc func emailTextFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        if text != self.email {
            self.errorMessage.isHidden = false
            self.okBtn.isEnabled = false
        } else {
            self.errorMessage.isHidden = true
            self.okBtn.isEnabled = true
        }
    }
    // MARK: - Functions
    func setUpContent() {
        titleLabel.text = self.titleText
        cancelBtn = UIButton().then{
            var config = UIButton.Configuration.plain()
            var attText = AttributedString.init(self.greenBtnText!)
            
            attText.font = UIFont.Suit(size: 14, family: .Medium)
            attText.foregroundColor = UIColor.wishboardGreen
            config.attributedTitle = attText
            
            $0.configuration = config
        }
        okBtn = UIButton().then{
            var config = UIButton.Configuration.plain()
            var attText = AttributedString.init(self.blackBtnText!)
            
            attText.font = UIFont.Suit(size: 14, family: .Medium)
            attText.foregroundColor = UIColor.black
            config.attributedTitle = attText
            
            $0.configuration = config
        }
        textField.placeholder = self.placeholder
    }
    func setUpView() {
        self.view.addSubview(popupView)
        
        popupView.addSubview(titleLabel)
        popupView.addSubview(messageLabel)
        popupView.addSubview(horizontalSeperator)
        popupView.addSubview(verticalSeperator)
        popupView.addSubview(cancelBtn)
        popupView.addSubview(okBtn)
        popupView.addSubview(textField)
        popupView.addSubview(errorMessage)
    }
    func setUpConstraint() {
        popupView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(260)
            make.centerY.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        horizontalSeperator.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview().offset(-48)
            make.leading.trailing.equalToSuperview()
        }
        verticalSeperator.snp.makeConstraints { make in
            make.width.equalTo(0.5)
            make.bottom.centerX.equalToSuperview()
            make.top.equalTo(horizontalSeperator.snp.bottom)
        }
        cancelBtn.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(horizontalSeperator.snp.bottom)
            make.leading.bottom.equalToSuperview()
            make.trailing.equalTo(verticalSeperator.snp.leading)
        }
        okBtn.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.centerY.equalTo(cancelBtn)
            make.trailing.bottom.equalToSuperview()
            make.leading.equalTo(verticalSeperator.snp.trailing)
        }
        textField.snp.makeConstraints { make in
            make.height.equalTo(42)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(horizontalSeperator.snp.top).offset(-32)
//            make.top.equalTo(messageLabel.snp.bottom).offset(20)
        }
        errorMessage.snp.makeConstraints { make in
            make.leading.equalTo(textField)
            make.top.equalTo(textField.snp.bottom).offset(6)
        }
    }
}
// MARK: - TextField & Keyboard Methods
extension PopUpDeleteUserViewController: UITextFieldDelegate {
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
