//
//  CalenderView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import Foundation
import UIKit
import FSCalendar

class CalenderView: UIView {
    // MARK: - View
    let backButton = UIButton().then{
        $0.setImage(UIImage(named: "goBack"), for: .normal)
    }
    
    // MARK: - Life Cycles
    var calender: FSCalendar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCalender()
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
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
    func setUpView() {
        addSubview(backButton)
        addSubview(calender)
    }
    func setUpConstraint() {
        backButton.snp.makeConstraints { make in
            make.width.equalTo(18)
            make.height.equalTo(14)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(66)
        }
        calender.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(385)
        }
    }
}
