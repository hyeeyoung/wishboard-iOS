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
    
    let backButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        config.image = Image.goBack
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    let weekSeperator = UIView().then{
        $0.backgroundColor = .gray_100
    }
    let underSeperator = UIView().then{
        $0.backgroundColor = .gray_100
    }
    
    //MARK: - Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setCalender()
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
            
            $0.appearance.headerTitleColor = .gray_700
            $0.appearance.weekdayTextColor = .gray_700
            $0.appearance.headerTitleFont = TypoStyle.MontserratH1.font
            $0.appearance.titleFont = TypoStyle.SuitD1.font   // 날(1...31일) 폰트
            $0.appearance.weekdayFont = TypoStyle.MontserratB2.font       // 상단 월화수목금 폰트
            $0.appearance.subtitleFont = TypoStyle.SuitH3.font
            
            $0.appearance.todayColor = .green_500
            $0.appearance.titleTodayColor = .gray_700
            $0.appearance.selectionColor = .clear
            $0.appearance.todaySelectionColor = .green_500
            $0.appearance.titleSelectionColor = .gray_700
            
            // 이벤트가 있는 날짜는 투명도가 높은 green색이 덧씌워진다.
            $0.appearance.eventDefaultColor = .green_alpha
            $0.appearance.eventSelectionColor = .green_alpha
        }
        contentView.addSubview(calender)
        contentView.addSubview(backButton)
        calender.addSubview(weekSeperator)
        calender.addSubview(underSeperator)
        
        calender.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(385)
        }
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.leading.equalToSuperview().offset(6)
            make.top.equalToSuperview().offset(6)
        }
        weekSeperator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        underSeperator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
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
    func setUpCalenderData(_ result: [NotificationModel]) {
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
}
