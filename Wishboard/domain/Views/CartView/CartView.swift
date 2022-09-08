//
//  CartView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import Foundation
import UIKit

class CartView: UIView {
    // MARK: - Properties
    // Navigation View
    let navigationView = UIView()
    let pageTitle = UILabel().then{
        $0.text = "장바구니"
        $0.font = UIFont.Suit(size: 15, family: .Bold)
    }
    let backButton = UIButton().then{
        $0.setImage(UIImage(named: "goBack"), for: .normal)
    }
    // lower View
    let lowerView = UIView().then{
        $0.backgroundColor = UIColor(named: "WishBoardColor")
    }
    let total = UILabel().then{
        $0.text = "전체"
        $0.font = UIFont.nanumSquare(size: 16)
    }
    let countLabel = UILabel().then{
        $0.text = "__"
        $0.font = UIFont.monteserrat(size: 16)
    }
    let label = UILabel().then{
        $0.text = "개"
        $0.font = UIFont.nanumSquare(size: 16)
    }
    let price = UILabel().then{
        $0.text = "0000"
        $0.font = UIFont.monteserrat(size: 16)
    }
    let won = UILabel().then{
        $0.text = "원"
        $0.font = UIFont.nanumSquare(size: 16)
    }
    // MARK: - Life Cycles
    var cartTableView: UITableView!
    var cartData: [CartListModel] = []
    var itemPrice = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTableView()
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setTableView() {
        cartTableView = UITableView()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
        
        // autoHeight
        cartTableView.rowHeight = UITableView.automaticDimension
        cartTableView.estimatedRowHeight = UITableView.automaticDimension
        cartTableView.showsVerticalScrollIndicator = false
    }
    func setUpView() {
        addSubview(navigationView)
        
        navigationView.addSubview(pageTitle)
        navigationView.addSubview(backButton)
        
        addSubview(lowerView)
        lowerView.addSubview(total)
        lowerView.addSubview(countLabel)
        lowerView.addSubview(label)
        lowerView.addSubview(price)
        lowerView.addSubview(won)
        
        addSubview(cartTableView)
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        setUpLowerConstraint()
        
        cartTableView.snp.makeConstraints { make in
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
        pageTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
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
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        total.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(17)
        }
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(total.snp.trailing).offset(4)
        }
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(countLabel.snp.trailing)
        }
        won.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-18)
        }
        price.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(won.snp.leading)
        }
    }
}
// MARK: - Main TableView delegate
extension CartView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = cartData.count ?? 0
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        
        let itemIdx = indexPath.item
        cell.setUpData(self.cartData[itemIdx])
        
        cell.deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension CartView {
    @objc func deleteItem() {
        self.cartTableView.reloadData()
    }
}
extension CartView {
    func setTempData() {
        self.cartData.append(CartListModel(itemImage: "", itemName: "item10", itemPrice: 10000, itemCount: 1))
        self.cartData.append(CartListModel(itemImage: "", itemName: "item11", itemPrice: 10000, itemCount: 3))
        self.cartData.append(CartListModel(itemImage: "", itemName: "item12", itemPrice: 20000, itemCount: 3))
        self.cartData.append(CartListModel(itemImage: "", itemName: "item13", itemPrice: 10000, itemCount: 1))
        self.cartData.append(CartListModel(itemImage: "", itemName: "item14", itemPrice: 10000, itemCount: 5))
        
        self.calculate()
        self.cartTableView.reloadData()
    }
    func calculate() {
        var totalPrice = 0
        var totalCount = 0
        for data in cartData {
            guard let initPrice = data.itemPrice else {return}
            guard let count = data.itemCount else {return}
            
            totalPrice = totalPrice + initPrice * count
            totalCount = totalCount + count
        }
        self.price.text = String(totalPrice)
        self.countLabel.text = String(totalCount)
    }
}
