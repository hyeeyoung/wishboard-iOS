//
//  CalenderNotiTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class CalenderNotiTableViewCell: UITableViewCell {
    // MARK: - Views
    let label = UILabel().then{
        $0.text = "_월 _일 일정"
        $0.font = UIFont.Suit(size: 14, family: .Bold)
    }
    
    //MARK: - Life Cycles
    var preVC: CalenderViewController!
    var noticeTableView: UITableView!
    var selectedDate: String!
    var notiData: [NotificationModel] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpTableView()
        setUpView()
        setUpConstraint()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setSelectedDate(_ date: String) {
        self.label.text = date + " 일정"
        self.selectedDate = date    // 00월 00일
        
        self.notiData.removeAll()
        NotificationDataManager().getCalenderNotificationDataManager(self)
    }
    func setUpTableView() {
        noticeTableView = UITableView().then{
            $0.delegate = self
            $0.dataSource = self
            $0.register(NotiTableViewCell.self, forCellReuseIdentifier: "NotiTableViewCell")
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
    }
    func setUpView() {
        contentView.addSubview(label)
        contentView.addSubview(noticeTableView)
    }
    func setUpConstraint() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(16)
        }
        noticeTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(label.snp.bottom).offset(13)
            make.bottom.equalToSuperview()
        }
    }
}
// MARK: - TableView delegate
extension CalenderNotiTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = notiData.count ?? 0
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotiTableViewCell", for: indexPath) as? NotiTableViewCell else { return UITableViewCell() }
        let itemIdx = indexPath.item
        cell.setCalenderNotiCell(self.notiData[itemIdx])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemIdx = indexPath.item
        let vc = ItemDetailViewController()
        vc.itemId = self.notiData[itemIdx].item_id
        self.preVC.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - API Success
extension CalenderNotiTableViewCell {
    func getCalenderNotificationAPISuccess(_ result: [NotificationModel]) {
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM월 dd일" // 2020년 08월 13일 오후 04시 30분
        myDateFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)

        for data in result {
            print(data)
            let dateStr = myDateFormatter.string(from: (data.item_notification_date?.toCreatedDate())!)
            if dateStr == self.selectedDate {
                self.notiData.append(data)
            }
        }
        // reload data with animation
        UIView.transition(with: noticeTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                              self.noticeTableView.reloadData()},
                          completion: nil);
    }
    func getCalenderNotificationAPIFail() {
        NotificationDataManager().getCalenderNotificationDataManager(self)
    }
}
