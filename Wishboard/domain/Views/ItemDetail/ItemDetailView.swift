//
//  ItemDetailView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import Foundation
import UIKit

class ItemDetailView: UIView {
    // MARK: - Properties
    // Navigation View
    let navigationView = UIView()
    let modifyButton = UIButton().then{
        $0.setImage(UIImage(named: "pencil"), for: .normal)
    }
    let deleteButton = UIButton().then{
        $0.setImage(UIImage(named: "trash"), for: .normal)
    }
    let backButton = UIButton().then{
        $0.setImage(UIImage(named: "goBack"), for: .normal)
    }
    
    // MARK: - Life Cycles
    var lowerView: UIView!
    var itemDetailTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTableView()
        setUpNavigationView()
        setUpLowerView(false)
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setTableView() {
        itemDetailTableView = UITableView()
        itemDetailTableView.delegate = self
        itemDetailTableView.dataSource = self
        itemDetailTableView.register(ItemDetailTableViewCell.self, forCellReuseIdentifier: "ItemDetailTableViewCell")
        
        // autoHeight
        itemDetailTableView.rowHeight = UITableView.automaticDimension
        itemDetailTableView.estimatedRowHeight = UITableView.automaticDimension
        itemDetailTableView.showsVerticalScrollIndicator = false
    }
    func setUpNavigationView() {
        addSubview(navigationView)
        
        navigationView.addSubview(modifyButton)
        navigationView.addSubview(deleteButton)
        navigationView.addSubview(backButton)
    }
    func setUpLowerView(_ isLinkExist: Bool) {
        // lower View
        lowerView = UIView()
        lowerView.then{
            if isLinkExist {$0.backgroundColor = .black}
            else {$0.backgroundColor = .white}
        }
        let lowerButton = UIButton().then{
            var config = UIButton.Configuration.plain()
            var attText = AttributedString.init("쇼핑몰로 이동하기")
            
            attText.font = .Suit(size: 16, family: .Bold)
            if isLinkExist {
                attText.foregroundColor = UIColor.white
                config.attributedTitle = attText
                config.background.backgroundColor = .black
            } else {
                attText.foregroundColor = .wishboardGray
                config.attributedTitle = attText
                config.background.backgroundColor = .white
            }
            
            $0.configuration = config
        }
        
        addSubview(lowerView)
        lowerView.addSubview(lowerButton)
        addSubview(itemDetailTableView)
        
        lowerView.snp.makeConstraints { make in
            if CheckNotch().hasNotch() {make.height.equalTo(78)}
            else {make.height.equalTo(44)}
            make.leading.trailing.bottom.equalToSuperview()
        }
        lowerButton.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        
        itemDetailTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
            make.bottom.equalTo(lowerView.snp.top)
        }
    }
    func setUpNavigationConstraint() {
        navigationView.snp.makeConstraints { make in
            if CheckNotch().hasNotch() {make.top.equalToSuperview().offset(50)}
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
            make.width.equalTo(18)
            make.height.equalTo(14)
            make.leading.equalToSuperview().offset(16)
        }
    }
}
// MARK: - Main TableView delegate
extension ItemDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailTableViewCell", for: indexPath) as? ItemDetailTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height + self.lowerView.frame.height + 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
