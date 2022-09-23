//
//  UploadItemView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/15.
//

import Foundation
import UIKit

class UploadItemView: UIView {
    // MARK: - View
    let navigationView = UIView()
    let pageTitle = UILabel().then{
        $0.text = "아이템 추가"
        $0.font = UIFont.Suit(size: 15, family: .Bold)
    }
    let backButton = UIButton().then{
        $0.setImage(UIImage(named: "goBack"), for: .normal)
    }
    var saveButton = UIButton().then{
        $0.defaultButton("저장", .wishboardGreen, .black)
    }
    
    // MARK: - Life Cycles
    var uploadItemTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    // 저장버튼 Enabled 여부
    func setSaveButton(_ isEnable: Bool) {
        if isEnable {
            saveButton.defaultButton("저장", .wishboardGreen, .black)
            saveButton.isEnabled = true
        }
        else {
            saveButton.defaultButton("저장", .wishboardDisabledGray, .gray)
            saveButton.isEnabled = false
        }
    }
    func setTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        uploadItemTableView = UITableView().then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(UploadItemPhotoTableViewCell.self, forCellReuseIdentifier: "UploadItemPhotoTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
        }
    }
    func setUpView() {
        addSubview(navigationView)
        navigationView.addSubview(pageTitle)
        navigationView.addSubview(backButton)
        navigationView.addSubview(saveButton)
        
        addSubview(uploadItemTableView)
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        
        uploadItemTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }
    }
    func setUpNavigationConstraint() {
        navigationView.snp.makeConstraints { make in
            if CheckNotch().hasNotch() {make.top.equalToSuperview().offset(50)}
            else {make.top.equalToSuperview().offset(20)}
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        pageTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(18)
            make.height.equalTo(14)
            make.leading.equalToSuperview().offset(16)
        }
        saveButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}