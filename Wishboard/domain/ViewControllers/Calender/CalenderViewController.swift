//
//  CalenderViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit
import FSCalendar

class CalenderViewController: UIViewController {
    var calenderView: CalenderView!
    var selectedDate: String!
    
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
        
        calenderView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    @objc func goBack() {
        self.dismiss(animated: true)
    }

}
// MARK: - TableView delegate
extension CalenderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag{
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderTableViewCell", for: indexPath) as? CalenderTableViewCell else { return UITableViewCell() }
            cell.setCalenderDelegate(dataSourceDelegate: self)
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderNotiTableViewCell", for: indexPath) as? CalenderNotiTableViewCell else { return UITableViewCell() }
            if let date = self.selectedDate {cell.setSelectedDate(date); cell.selectedDate = date}
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tag = indexPath.row
        switch tag{
        case 0:
            return 385
        default:
            return tableView.frame.height - 385
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - Calender delegate
extension CalenderViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM월 dd일" // 2020년 08월 13일 오후 04시 30분
        myDateFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)
        let convertStr = myDateFormatter.string(from: date)
        
        self.selectedDate = convertStr
        // reload data with animation
        UIView.transition(with: calenderView.calenderTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                              self.calenderView.calenderTableView.reloadData()},
                          completion: nil);
    }
}
