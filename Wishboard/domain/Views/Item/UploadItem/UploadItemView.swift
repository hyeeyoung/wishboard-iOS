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
    let pageTitle = DefaultLabel().then{
        $0.text = Title.addItem
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitH3)
    }
    let backButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        config.image = Image.goBack
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    var saveButton = DefaultButton(titleStr: Button.save).then{
        $0.isActivate = true
        $0.layer.cornerRadius = 15
        $0.titleLabel?.setTypoStyleWithSingleLine(typoStyle: .SuitB3)
    }
    
    let scrollView = UIScrollView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }
    // MARK: - Life Cycles
    var uploadImageTableView: UITableView!
    var uploadContentTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    // 저장버튼 Enabled 여부
    func setSaveButton(_ isEnable: Bool) {
        saveButton.isActivate = isEnable ? true : false
    }
    func setImageTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        uploadImageTableView = UITableView().then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(UploadItemPhotoTableViewCell.self, forCellReuseIdentifier: "UploadItemPhotoTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            // scroll disable
            $0.isScrollEnabled = false
            $0.isPagingEnabled = false
            
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func setContentTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        uploadContentTableView = UITableView().then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(UploadItemTextfieldTableViewCell.self, forCellReuseIdentifier: "UploadItemTextfieldTableViewCell")
            $0.register(UploadItemBottomSheetTableViewCell.self, forCellReuseIdentifier: "UploadItemBottomSheetTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
            $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func setUpView() {
        addSubview(navigationView)
        navigationView.addSubview(pageTitle)
        navigationView.addSubview(backButton)
        navigationView.addSubview(saveButton)
        
        addSubview(scrollView)
        scrollView.addSubview(uploadImageTableView)
        scrollView.addSubview(uploadContentTableView)
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }
        uploadImageTableView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(251)
        }
        uploadContentTableView.snp.makeConstraints { make in
            make.top.equalTo(uploadImageTableView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalTo(scrollView)
            make.height.equalTo(500)
        }
    }
    func setUpNavigationConstraint() {
        navigationView.snp.makeConstraints { make in
            if UIDevice.current.hasNotch {make.top.equalToSuperview().offset(50)}
            else {make.top.equalToSuperview().offset(20)}
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        pageTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
            make.leading.equalToSuperview().offset(6)
        }
        saveButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(57)
            make.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
