//
//  BottomSheetKeyboardViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/10/12.
//

import UIKit

class BottomSheetKeyboardViewController: BaseViewController {
    // MARK: - Properties
    // keyboard
    var restoreFrameValue: CGFloat = 0.0
    var textfieldY: CGFloat = 244
    var buttonHeight: CGFloat = 66
    var textfield: UITextField!
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.addSubview(navigationTitle)
        navigationTitle.snp.makeConstraints{
            $0.centerY.centerX.equalToSuperview()
        }
        
        if let textfield = self.textfield { textfield.delegate = self }
    }
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
