//
//  NotificationSettingViewController.swift
//  Share Extension
//
//  Created by gomin on 2022/09/25.
//

import UIKit

class NotificationSettingViewController: UIViewController {
    
    let titleLabel = UILabel().then{
        $0.text = "상품 알림 설정"
        $0.font = UIFont.Suit(size: 14, family: .Bold)
    }
    let exitBtn = UIButton().then{
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    let notificationPickerView = UIPickerView().then{
        $0.tintColor = .black
    }
    let message = UILabel().then{
        $0.text = "30분 전에 상품 일정을 알려드려요! 시간은 30분 단위로 설정할 수 있어요."
        $0.font = UIFont.Suit(size: 8, family: .Regular)
        $0.textColor = .wishboardGray
    }
    let completeButton = UIButton().then{
        $0.defaultButton("완료", .wishboardGreen, .black)
    }
    // MARK: - Life Cycles
    var notiType: String?
    var dateAndTime: String?
    var date: String = ""
    var hour: String = "00"
    var minute: String = "00"
    
    var preVC: ShareViewController!
    var isExit: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.view.roundCornersDiffernt(topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0)
        
        setUpView()
        setUpConstraint()
        
        notificationPickerView.delegate = self
        notificationPickerView.dataSource = self
        
        self.exitBtn.addTarget(self, action: #selector(exit), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(goShareLinkPage), for: .touchUpInside)
        
        SetNotificationDate()
    }
    // MARK: 현재 뷰가 사라질 때, 이전 뷰의 날짜Label을 업데이트 시킨다. **
    override func viewWillDisappear(_ animated: Bool) {
        if !isExit {
            guard let dT = self.dateAndTime else {return}
            guard let nT = self.notiType else {return}
            self.preVC.shareView.setNotificationButton.setNotificationButton(dT + " " + nT, true)
            preVC.notificationType = nT
            preVC.notificationDate = dT
            
            preVC.view.endEditing(true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    // MARK: - Functions
    func setPreViewController(_ preVC: ShareViewController) {
        self.preVC = preVC
    }
    func setUpView() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(exitBtn)
        self.view.addSubview(notificationPickerView)
        self.view.addSubview(message)
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
        notificationPickerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(65)
            make.height.equalTo(100)
        }
        message.snp.makeConstraints { make in
            make.leading.equalTo(notificationPickerView)
            make.top.equalTo(notificationPickerView.snp.bottom).offset(43)
        }
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(message.snp.bottom).offset(16)
        }
    }
    // MARK: - Actions
    @objc func exit() {
        UIDevice.vibrate()
        self.isExit = true
        self.dismiss(animated: true)
    }
    @objc func goShareLinkPage() {
        UIDevice.vibrate()
        self.isExit = false
        if self.notiType == nil {self.notiType = "재입고"}
        if self.dateAndTime == nil {
            let setNotificationDate = SetNotificationDate()
            self.date = setNotificationDate.currentYear + "년 " + setNotificationDate.currentMonth + "월 " + setNotificationDate.currentDay + "일"
            self.dateAndTime = self.date + " " + self.hour + ":" + self.minute
        }
        
        self.dismiss(animated: true)
    }
}
// MARK: - Picker delegate
extension NotificationSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 5
        case 1:
            return 90
        case 2:
            return 24
        case 4:
            return 2
        default:
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return SetNotificationDate().notificationData[row]
        case 1:
            return SetNotificationDate().dateData[row]
        case 2:
            return SetNotificationDate().hourData[row]
        case 4:
            return SetNotificationDate().minuteData[row]
        default:
            return ":"
        }
        
    }
    // font 적용
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont.Suit(size: 14, family: .Regular)
        label.textAlignment = .center
        
        switch component {
        case 0:
            label.text = SetNotificationDate().notificationData[row]
        case 1:
            label.text = SetNotificationDate().dateData[row]
        case 2:
            label.text = SetNotificationDate().hourData[row]
        case 4:
            label.text = SetNotificationDate().minuteData[row]
        default:
            label.text = ":"
        }
        
        return label
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 80
        case 1:
            return 120
        case 2:
            return 30
        case 4:
            return 30
        default:
            return 5
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.notiType = SetNotificationDate().notificationData[row]
        case 1:
            self.date = SetNotificationDate().dateData[row]
            self.dateAndTime = self.date + " " + self.hour + ":" + self.minute
        case 2:
            self.hour = SetNotificationDate().hourData[row]
            self.dateAndTime = self.date + " " + self.hour + ":" + self.minute
        case 4:
            self.minute = SetNotificationDate().minuteData[row]
            self.dateAndTime = self.date + " " + self.hour + ":" + self.minute
        default:
            self.dateAndTime = self.date + " " + self.hour + ":" + self.minute
        }
    }
}
