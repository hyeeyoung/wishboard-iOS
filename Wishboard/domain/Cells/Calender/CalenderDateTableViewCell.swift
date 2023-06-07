//
//  CalenderDateTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/11/01.
//

import UIKit

class CalenderDateTableViewCell: UITableViewCell {
    // MARK: - Views
    let label = DefaultLabel().then{
        $0.text = "_월 _일 일정"
        $0.font = UIFont.Suit(size: 14, family: .Bold)
    }

    // MARK: - Life Cycle
    var selectedDate: String!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(16)
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setSelectedDate(_ date: String) {
        self.label.text = date + " 일정"
        self.selectedDate = date    // 00월 00일
    }
}
