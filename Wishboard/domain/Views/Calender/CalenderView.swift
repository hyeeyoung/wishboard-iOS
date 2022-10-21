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
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "goBack")
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    
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
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
    }
    func setUpView() {
        addSubview(calenderTableView)
        addSubview(backButton)
    }
    func setUpConstraint() {
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.leading.equalToSuperview().offset(6)
            if CheckNotch().hasNotch() {make.top.equalToSuperview().offset(56)}
            else {make.top.equalToSuperview().offset(25)}
        }
        calenderTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            if CheckNotch().hasNotch() {make.top.equalToSuperview().offset(50)}
            else {make.top.equalToSuperview().offset(20)}
        }
    }
}
