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
    // MARK: - Life Cycles
    var calenderTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        calenderTableView = UITableView().then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(CalenderTableViewCell.self, forCellReuseIdentifier: "CalenderTableViewCell")
            $0.register(CalenderNotiTableViewCell.self, forCellReuseIdentifier: "CalenderNotiTableViewCell")
            $0.register(CalenderDateTableViewCell.self, forCellReuseIdentifier: "CalenderDateTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        }
    }
    func setUpView() {
        addSubview(calenderTableView)
    }
    func setUpConstraint() {
        calenderTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            if CheckNotch().hasNotch() {make.top.equalToSuperview().offset(50)}
            else {make.top.equalToSuperview().offset(20)}
        }
    }
}
