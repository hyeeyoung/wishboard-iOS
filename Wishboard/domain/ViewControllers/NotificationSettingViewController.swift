//
//  NotificationSettingViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/15.
//

import UIKit

class NotificationSettingViewController: UIViewController {
    let notificationData = ["세일 마감", "재입고", "프리오더 시작"]
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
    // font custom 불가
    let dateAndTimePickerView = UIDatePicker().then{
        $0.datePickerMode = .dateAndTime
        $0.preferredDatePickerStyle = .wheels
        $0.setValue(UIColor.black, forKeyPath: "textColor")
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
    var preVC: UploadItemViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.view.roundCornersDiffernt(topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0)
        
        self.notiType = "세일 마감"
        self.dateAndTime = formatDate(Date())

        setUpView()
        setUpConstraint()
        
        notificationPickerView.delegate = self
        notificationPickerView.dataSource = self
        
        self.exitBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    // MARK: 현재 뷰가 사라질 때, 이전 뷰의 테이블뷰를 업데이트 시킨다. **
    override func viewWillDisappear(_ animated: Bool) {
        self.preVC.uploadItemView.uploadItemTableView.reloadData()
    }
    // MARK: - Functions
    func setPreViewController(_ preVC: UploadItemViewController) {
        self.preVC = preVC
    }
    func setUpView() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(exitBtn)
        self.view.addSubview(notificationPickerView)
        self.view.addSubview(dateAndTimePickerView)
        self.view.addSubview(message)
        self.view.addSubview(completeButton)
        
        dateAndTimePickerView.addTarget(self, action: #selector(setDateAndTime), for: .valueChanged)
        completeButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
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
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(65)
            make.height.equalTo(85)
            make.width.equalTo(100)
        }
        dateAndTimePickerView.snp.makeConstraints { make in
            make.leading.equalTo(notificationPickerView.snp.trailing)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.height.equalTo(notificationPickerView)
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
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    @objc func setDateAndTime() {
        self.dateAndTime = formatDate(dateAndTimePickerView.date)
    }
    @objc func goUploadPage() {
        self.dismiss(animated: true)
    }
    // Date를 String으로 format
    func formatDate(_ date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy.MM.dd a hh:mm"
        let dateStr = dateformatter.string(from: date)
        
        return dateStr
    }
}
// MARK: - Picker delegate
extension NotificationSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return notificationData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return notificationData[row]
    }
    // font 적용
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont.Suit(size: 14, family: .Regular)
        label.text =  notificationData[row]
        label.textAlignment = .center
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.notiType = notificationData[row]
        print(notificationData[row])
    }
}
