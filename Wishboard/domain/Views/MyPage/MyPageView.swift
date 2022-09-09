//
//  MyPageView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import Foundation
import UIKit

class MyPageView: UIView {
    // MARK: - View
    let navigationView = UIView()
    let titleLabel = UILabel().then{
        $0.text = "마이페이지"
        $0.font = UIFont.Suit(size: 22, family: .Bold)
    }
    // MARK: - Life Cycles
    var mypageTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        setTableView()
//        setUpView()
//        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        mypageTableView = UITableView()
        mypageTableView.then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(MypageProfileTableViewCell.self, forCellReuseIdentifier: "MypageProfileTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
        }
        
    }
    func setUpView() {
        addSubview(navigationView)
        navigationView.addSubview(titleLabel)
        
        addSubview(mypageTableView)
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        
        mypageTableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }
    }
    func setUpNavigationConstraint() {
        navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
    }
}
