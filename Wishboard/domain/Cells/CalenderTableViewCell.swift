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
    
    //MARK: - Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setCalender()
        
        contentView.addSubview(calender)
        calender.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(385)
        }
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
            $0.appearance.headerMinimumDissolvedAlpha = 0
            $0.locale = Locale(identifier: "en")
            
            $0.appearance.headerTitleColor = .black
            $0.appearance.weekdayTextColor = .black
            $0.appearance.headerTitleFont = UIFont.Suit(size: 22, family: .Bold)
            $0.appearance.titleFont = UIFont.Suit(size: 16, family: .Light)
            $0.appearance.weekdayFont = UIFont.Suit(size: 16, family: .Light)
            
            $0.appearance.selectionColor = UIColor(named: "WishBoardColor")
            $0.appearance.todaySelectionColor = UIColor(named: "WishBoardColor")
            $0.appearance.titleSelectionColor = .black
        }
    }
}
