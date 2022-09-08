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
    let menuButton = UIButton().then{
        $0.setImage(UIImage(named: "ic_menu"), for: .normal)
    }
    let backButton = UIButton().then{
        $0.setImage(UIImage(named: "goBack"), for: .normal)
    }
    // lower View
    let lowerView = UIView().then{
        $0.backgroundColor = .black
    }
    let lowerButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        var attText = AttributedString.init("쇼핑몰로 이동하기")
        
        attText.font = .Suit(size: 16, family: .Bold)
        attText.foregroundColor = UIColor.white
        config.attributedTitle = attText
        config.background.backgroundColor = .black
        
        $0.configuration = config
    }
    // MARK: - Life Cycles
    var itemDetailTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTableView()
        setUpView()
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
    func setUpView() {
        addSubview(navigationView)
        
        navigationView.addSubview(menuButton)
        navigationView.addSubview(backButton)
        
        addSubview(lowerView)
        lowerView.addSubview(lowerButton)
        addSubview(itemDetailTableView)
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        setUpLowerConstraint()
        
        itemDetailTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
            make.bottom.equalTo(lowerView.snp.top)
        }
    }
    func setUpNavigationConstraint() {
        navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        menuButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(3)
            make.height.equalTo(16)
            make.trailing.equalToSuperview().offset(-18)
        }
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(18)
            make.height.equalTo(14)
            make.leading.equalToSuperview().offset(16)
        }
    }
    func setUpLowerConstraint() {
        lowerView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
        lowerButton.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
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
