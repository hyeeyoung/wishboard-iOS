//
//  BottomSheetKeyboardViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/10/12.
//

import UIKit
import SnapKit
import Then

/* Need Setting
     - title
     - textfield placeholder
     - text count label isHidden
     - errorMessage text
     - complete button title
     - complete button activate
 */

class BottomSheetKeyboardViewController: BaseViewController {
    let titleLabel = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitH3)
        $0.sizeToFit()
    }
    let exitBtn = UIButton().then{
        $0.setImage(Image.quit, for: .normal)
    }
    var textfield: DefaultTextField!
    
    let textFieldCountLabel = UILabel().then{
        $0.text = Message.count
        $0.textColor = .gray_200
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
    }
    let errorMessage = UILabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
        $0.textColor = .pink_700
    }
    var completeButton: LoadingButton!
    
    // MARK: - Properties
    // keyboard
    var restoreFrameValue: CGFloat = 0.0
    var textfieldY: CGFloat = 244
    var buttonHeight: CGFloat = 66
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initComponents()
        addTarget()
        setUpView()
        setUpConstraint()
        
    }
    
    private func addTarget() {
        textfield.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        exitBtn.addTarget(self, action: #selector(exit), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }
    
    func initComponents() {
        textfield = DefaultTextField("").then{
            $0.clearButtonMode = .whileEditing
        }
        if let textfield = self.textfield { textfield.delegate = self }
        
        completeButton = LoadingButton("")
    }
    
    private func setUpView() {
        super.backBtn.isHidden = true
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.view.roundCornersDiffernt(topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0)

        navigationView.addSubview(navigationTitle)
        navigationTitle.snp.makeConstraints{
            $0.centerY.centerX.equalToSuperview()
        }
        
        addSubView()
        
    }
    private func addSubView() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(exitBtn)
        self.view.addSubview(textfield)
        self.view.addSubview(textFieldCountLabel)
        self.view.addSubview(errorMessage)
        self.view.addSubview(completeButton)
    }
    private func setUpConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        exitBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
        }
        textfield.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(77)
            make.height.equalTo(42)
        }
        textFieldCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(textfield)
            make.top.equalTo(textfield.snp.bottom).offset(6)
        }
        errorMessage.snp.makeConstraints { make in
            make.leading.equalTo(textfield)
            make.top.equalTo(textfield.snp.bottom).offset(6)
        }
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.greaterThanOrEqualTo(textfield.snp.bottom).offset(86)
            make.bottom.equalToSuperview().offset(-34)
        }
    }
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {}
    
    @objc func exit() {
        UIDevice.vibrate()
        self.dismiss(animated: true)
    }
    
    @objc func completeButtonDidTap() {}
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    override func viewDidAppear(_ animated: Bool) {
//        if let textfield = self.textfield {self.textfield.becomeFirstResponder()}
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.removeKeyboardNotifications()
    }
    // MARK: - Functions
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
            let keyboardY = self.view.frame.height - keyboardHeight
//            if keyboardY - self.buttonHeight < self.textfieldY {
//                self.view.bounds.origin.y +=  self.buttonHeight
//                print("appear")
//            }
        }
    }
    
    @objc func keyboardWillDisappear(noti: NSNotification) {
        if self.view.bounds.origin.y != restoreFrameValue {
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                let keyboardY = self.view.frame.height - keyboardHeight
//                if keyboardY - self.buttonHeight < self.textfieldY {
//                    self.view.bounds.origin.y -=  self.buttonHeight
//                    print("disappear")
//                }
            }
        }
    }
}
extension BottomSheetKeyboardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.bounds.origin.y = self.restoreFrameValue
        return true
    }
}
