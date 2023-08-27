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
    let titleLabel = DefaultLabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitH3)
    }
    let messageLabel = UILabel().then{
        $0.text = Message.deleteUser
        $0.setTypoStyleWithMultiLine(typoStyle: .SuitD2)
        $0.textColor = .gray_300
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let horizontalSeperator = UIView().then{
        $0.backgroundColor = .gray_100
    }
    let verticalSeperator = UIView().then{
        $0.backgroundColor = .gray_100
    }
    var cancelBtn: UIButton!
    var okBtn: UIButton!
    var textField = DefaultTextField("").then{
        $0.keyboardType = .emailAddress
        $0.clearButtonMode = .always
    }
    let errorMessage = UILabel().then{
        $0.text = ErrorMessage.email
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
        $0.textColor = .pink_700
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
        self.view.backgroundColor = .black_4
        self.errorMessage.isHidden = true
        
        cancelBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        textField.addTarget(self, action: #selector(emailTextFieldEditingChanged(_:)), for: .allEditingEvents)
        okBtn.addTarget(self, action: #selector(signOutButtonDidTap), for: .touchUpInside)
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
        errorMessage.isHidden = true
    }
    @objc func signOutButtonDidTap() {
        print("tap")
        let input = textField.text ?? ""
        if input != self.email {
            errorMessage.isHidden = false
        } else {
            self.dismiss(animated: false)
            MypageDataManager().deleteUserDataManager(self)
        }
        UIDevice.vibrate()
    }
    // MARK: - Functions
    func setUpContent() {
        titleLabel.text = self.titleText
        cancelBtn = UIButton().then{
            var config = UIButton.Configuration.plain()
            var attText = AttributedString.init(self.greenBtnText!)
            
            attText.font = TypoStyle.SuitB3.font
            attText.foregroundColor = UIColor.green_700
            config.attributedTitle = attText
            
            $0.configuration = config
        }
        okBtn = UIButton().then{
            var config = UIButton.Configuration.plain()
            var attText = AttributedString.init(self.blackBtnText!)
            
            attText.font = TypoStyle.SuitB3.font
            attText.foregroundColor = UIColor.gray_700
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
extension PopUpDeleteUserViewController {
    // MARK: 회원 탈퇴 API
    func deleteUserAPISuccess(_ result: APIModel<TokenResultModel>) {
        // delete UserInfo
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "isFirstLogin")
        UserDefaults(suiteName: "group.gomin.Wishboard.Share")?.removeObject(forKey: "accessToken")
        UserDefaults(suiteName: "group.gomin.Wishboard.Share")?.removeObject(forKey: "removeToken")
        
        let onboardingVC = OnBoardingViewController(usecase: .signOut)
        let navigationController = UINavigationController(rootViewController: onboardingVC)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(navigationController, animated: true)
        
        print(result.message)
    }
}
