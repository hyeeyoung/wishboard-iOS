//
//  ItemDetailView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import Foundation
import UIKit
import SnapKit

class ItemDetailView: UIView {
    // MARK: - Properties
    let navigationView = UIView()
    let modifyButton = UIButton().then{
        $0.setImage(Image.pencil, for: .normal)
    }
    let deleteButton = UIButton().then{
        $0.setImage(Image.trash, for: .normal)
    }
    let backButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        config.image = Image.goBack
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    
    var lowerView = UIView()
    var lowerButton = UIButton().then {
        $0.setTitle("쇼핑몰로 이동하기", for: .normal)
        $0.setTitle("쇼핑몰로 이동하기", for: .disabled)
        $0.setFont(font: TypoStyle.SuitH3.font, for: .normal)
        $0.setFont(font: TypoStyle.SuitH3.font, for: .disabled)
        
        $0.adjustsImageWhenHighlighted = false
        $0.isHighlighted = false
    }
    var itemDetailTableView = UITableView()
    
    // MARK: - Properties
    let LOWER_VIEW_HEIGHT: CGFloat = UIDevice.current.hasNotch ? 34 + 48 : 48
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        setUpConstraint()
        setLinkButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setTableView(_ dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        itemDetailTableView.delegate = dataSourceDelegate
        itemDetailTableView.dataSource = dataSourceDelegate
        itemDetailTableView.register(ItemDetailTableViewCell.self, forCellReuseIdentifier: "ItemDetailTableViewCell")
        
        // autoHeight
        itemDetailTableView.rowHeight = UITableView.automaticDimension
        itemDetailTableView.estimatedRowHeight = UITableView.automaticDimension
        itemDetailTableView.showsVerticalScrollIndicator = false
        itemDetailTableView.separatorStyle = .none
    }
    
    private func addSubViews() {
        addNavigationView()
        
        addSubview(lowerView)
        lowerView.addSubview(lowerButton)
        
        addSubview(itemDetailTableView)
    }
    private func addNavigationView() {
        addSubview(navigationView)
        
        navigationView.addSubview(modifyButton)
        navigationView.addSubview(deleteButton)
        navigationView.addSubview(backButton)
    }
   
   private func setUpConstraint() {
        setUpNavigationConstraint()
       
       lowerView.snp.makeConstraints { make in
           make.height.equalTo(LOWER_VIEW_HEIGHT)
           make.leading.trailing.bottom.equalToSuperview()
       }
       
       lowerButton.snp.makeConstraints { make in
           make.leading.trailing.top.equalToSuperview()
           make.height.equalTo(48)
       }
        
        itemDetailTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
            make.bottom.equalToSuperview().offset(-82)
        }
    }
    
    private func setUpNavigationConstraint() {
        navigationView.snp.makeConstraints { make in
            if UIDevice.current.hasNotch {make.top.equalToSuperview().offset(50)}
            else {make.top.equalToSuperview().offset(20)}
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        modifyButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
        }
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalTo(modifyButton.snp.leading).offset(-16)
        }
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
            make.leading.equalToSuperview().offset(6)
        }
    }
    
    private func setLinkButton() {
        lowerButton.setTitleColor(.white, for: .normal)
        lowerButton.setTitleColor(.gray_300, for: .disabled)
        
        lowerButton.setBackgroundColor(.gray_700, for: .normal)
        lowerButton.setBackgroundColor(.gray_100, for: .disabled)
    }
    
    // 쇼핑몰 링크 여부에 따라 버튼 활성화/비활성화 설정
    func activateLinkButton() {
        lowerButton.isEnabled = true

        lowerView.backgroundColor = .gray_700
    }
    
    func inactivateLinkButton() {
        lowerButton.isEnabled = false
        
        lowerView.backgroundColor = .gray_100
    }
}
