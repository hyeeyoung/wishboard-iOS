//
//  CalenderViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit
import FSCalendar

class CalenderViewController: UIViewController, Observer {
    var observer = WishItemObserver.shared
    
    var calenderView: CalenderView!
    var selectedDate: String!
    var calenderData: [NotificationModel] = []
    var notiData: [NotificationModel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        calenderView = CalenderView()
        self.view.addSubview(calenderView)
        
        calenderView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM월 dd일"
        myDateFormatter.locale = Locale(identifier:"ko_KR")
        self.selectedDate = myDateFormatter.string(from: Date())
        
        calenderView.setTableView(dataSourceDelegate: self)
        calenderView.setUpView()
        calenderView.setUpConstraint()
        
        // DATA
        DispatchQueue.main.async {
            NotificationDataManager().getCalenderNotificationDataManager(self)
        }
        
        observer.bind(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    func update(_ newValue: Any) {
        DispatchQueue.main.async {
            NotificationDataManager().getCalenderNotificationDataManager(self)
        }
    }
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
        UIDevice.vibrate()
    }

}
// MARK: - TableView delegate
extension CalenderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = notiData.count ?? 0
        EmptyView().setNotificationEmptyView(self.calenderView.calenderTableView, count, true)
        return count + 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag{
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderTableViewCell", for: indexPath) as? CalenderTableViewCell else { return UITableViewCell() }
            cell.setCalenderDelegate(dataSourceDelegate: self)
            cell.setUpCalenderData(self.calenderData)
            cell.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderDateTableViewCell", for: indexPath) as? CalenderDateTableViewCell else { return UITableViewCell() }
            if let date = self.selectedDate {cell.setSelectedDate(date)}
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderNotiTableViewCell", for: indexPath) as? CalenderNotiTableViewCell else { return UITableViewCell() }
            let itemIdx = indexPath.item
            cell.setCalenderNotiCell(self.notiData[itemIdx - 2])
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tag = indexPath.row
        switch tag{
        case 0:
            return 385
        case 1:
            return 62
        default:
            return 116
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIDevice.vibrate()
        
        let itemIdx = indexPath.item
        if itemIdx != 0 && itemIdx != 1 {
            let vc = ItemDetailViewController()
            vc.itemId = self.notiData[itemIdx - 2].item_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - API Success
extension CalenderViewController {
    // 캘린더에 표시하기 위해 전체 알람을 받아 캘린더이벤트로 출력
    func getCalenderNotificationAPISuccess(_ result: [NotificationModel]) {
        self.calenderData = result
        let indexPath = IndexPath(row: 0, section: 0)
        calenderView.calenderTableView.reloadRows(at: [indexPath], with: .automatic)
        
        // 선택한 날짜에 맞는 알람 출력
        setDateNotification()
    }
    func getCalenderNotificationAPIFail() {
        NotificationDataManager().getCalenderNotificationDataManager(self)
    }
    // 선택한 날짜에 맞는 알람 출력
    func setDateNotification() {
        self.notiData.removeAll()
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM월 dd일" // 2020년 08월 13일 오후 04시 30분
        myDateFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)

        for data in self.calenderData {
            if let createdDate = data.item_notification_date?.toCreatedDate() {
                let dateStr = myDateFormatter.string(from: (createdDate))
                if dateStr == self.selectedDate {
                    self.notiData.append(data)
                }
            } else {
                continue
            }
        }
        // reload data with animation
        calenderView.calenderTableView.reloadData()
    }
}
// MARK: - Calender delegate
extension CalenderViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        UIDevice.vibrate()
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM월 dd일" // 2020년 08월 13일 오후 04시 30분
        myDateFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)
        let convertStr = myDateFormatter.string(from: date)
        
        self.selectedDate = convertStr
        setDateNotification()
        // reload data with animation
        UIView.transition(with: calenderView.calenderTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                              self.calenderView.calenderTableView.reloadData()},
                          completion: nil);
    }
}
