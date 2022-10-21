//
//  CalenderTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit
import FSCalendar

class CalenderTableViewCell: UITableViewCell {
    var calender: FSCalendar!
    var events: [Date] = []
    
    let weekSeperator = UIView().then{
        $0.backgroundColor = .wishboardDisabledGray
    }
    let underSeperator = UIView().then{
        $0.backgroundColor = .wishboardDisabledGray
    }
    
    //MARK: - Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setCalender()
        
        NotificationDataManager().getCalenderNotificationDataManager(self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    func setCalenderDelegate(dataSourceDelegate: FSCalendarDelegate) {
        calender.delegate = dataSourceDelegate
    }
    func setCalender() {
        calender = FSCalendar().then{
            $0.delegate = self
            $0.dataSource = self
            
            $0.appearance.headerMinimumDissolvedAlpha = 0
            $0.locale = Locale(identifier: "en")
            
            $0.appearance.headerTitleColor = .black
            $0.appearance.weekdayTextColor = .black
            $0.appearance.headerTitleFont = UIFont.monteserrat(size: 20, family: .ExtraBold)
            $0.appearance.titleFont = UIFont.Suit(size: 16, family: .Regular)
            $0.appearance.weekdayFont = UIFont.monteserrat(size: 14, family: .Medium)
            $0.appearance.subtitleFont = UIFont.Suit(size: 16, family: .Bold)
            
            $0.appearance.todayColor = .wishboardGreen
            $0.appearance.titleTodayColor = .black
            $0.appearance.selectionColor = .wishboardGreen
            $0.appearance.todaySelectionColor = .wishboardGreen
            $0.appearance.titleSelectionColor = .black
            
            $0.appearance.eventDefaultColor = .wishboardLightGreen
            $0.appearance.eventSelectionColor = .wishboardLightGreen
        }
        contentView.addSubview(calender)
        calender.addSubview(weekSeperator)
        calender.addSubview(underSeperator)
        
        calender.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(385)
        }
        weekSeperator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        underSeperator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
// MARK: - Calender delegate
extension CalenderTableViewCell: FSCalendarDelegate, FSCalendarDataSource {
    //이벤트 표시 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.events.contains(date) {
            return 1
        } else {
            return 0
        }
    }
}
// MARK: - API Success
extension CalenderTableViewCell {
    func getCalenderNotificationAPISuccess(_ result: [NotificationModel]) {
        events.removeAll()
        for data in result {
            guard let notificationDate = data.item_notification_date else {return}
            let startIndex = notificationDate.index(notificationDate.startIndex, offsetBy: 0)// 사용자지정 시작인덱스
            let endIndex = notificationDate.index(notificationDate.startIndex, offsetBy: 10)// 사용자지정 끝인덱스
            var notificationDateStr = notificationDate[startIndex ..< endIndex]
            
            let dfMatter = DateFormatter()
            dfMatter.locale = Locale(identifier: "ko_KR")
            dfMatter.dateFormat = "yyyy-MM-dd"
            guard let eventDate = dfMatter.date(from: String(notificationDateStr)) else {return}
            
            events.append(eventDate)
        }
    }
    func getCalenderNotificationAPIFail() {
        NotificationDataManager().getCalenderNotificationDataManager(self)
    }
}
