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
        $0.backgroundColor = .wishboardGreen
    }
    let total = UILabel().then{
        $0.text = "전체"
        $0.font = UIFont.Suit(size: 14, family: .Regular)
    }
    let countLabel = UILabel().then{
        $0.text = "0"
        $0.font = UIFont.monteserrat(size: 18, family: .Bold)
    }
    let label = UILabel().then{
        $0.text = "개"
        $0.font = UIFont.Suit(size: 14, family: .Regular)
    }
    let price = UILabel().then{
        $0.text = "0"
        $0.font = UIFont.monteserrat(size: 18, family: .Bold)
    }
    let won = UILabel().then{
        $0.text = "원"
        $0.font = UIFont.Suit(size: 14, family: .Regular)
    }
    // MARK: - Life Cycles
    var cartTableView: UITableView!
    var cartData: [CartListModel] = []
    var itemPrice = 0
    let emptyMessage = "앗, 장바구니가 비어있어요!\n구매할 아이템을 장바구니에 담아보세요!"
    
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
        EmptyView().setEmptyView(self.emptyMessage, self.cartTableView, count)
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        
        let itemIdx = indexPath.item
        cell.setUpData(self.cartData[itemIdx])
        
        let plusGesture = CartGesture(target: self, action: #selector(plusButtonDidTap(_:)))
        let minusGesture = CartGesture(target: self, action: #selector(minusButtonDidTap(_:)))
        let deleteGesture = CartGesture(target: self, action: #selector(deleteButtonDidTap(_:)))
        
        plusGesture.cartItem = self.cartData[itemIdx]
        minusGesture.cartItem = self.cartData[itemIdx]
        deleteGesture.cartItem = self.cartData[itemIdx]
        
        cell.plusButton.addGestureRecognizer(plusGesture)
        cell.minusButton.addGestureRecognizer(minusGesture)
        cell.deleteButton.addGestureRecognizer(deleteGesture)
        
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
    // (+) 버튼 클릭
    @objc func plusButtonDidTap(_ sender: CartGesture) {
        guard let itemId = sender.cartItem?.wishItem?.item_id else {return}
        guard var itemCount = sender.cartItem?.cartItemInfo?.item_count else {return}
        itemCount = itemCount + 1
        
        let modifyCountInput = CartModifyCountInput(item_count: itemCount)
        CartDataManager().modifyCountDataManager(itemId, modifyCountInput, self)
    }
    // (-) 버튼 클릭
    @objc func minusButtonDidTap(_ sender: CartGesture) {
        guard let itemId = sender.cartItem?.wishItem?.item_id else {return}
        guard var itemCount = sender.cartItem?.cartItemInfo?.item_count else {return}
        if itemCount == 1 {return}
        else {itemCount = itemCount - 1}
        
        let modifyCountInput = CartModifyCountInput(item_count: itemCount)
        CartDataManager().modifyCountDataManager(itemId, modifyCountInput, self)
    }
    // (X) 버튼 클릭
    @objc func deleteButtonDidTap(_ sender: CartGesture) {
        guard let itemId = sender.cartItem?.wishItem?.item_id else {return}
        CartDataManager().deleteCartDataManager(itemId, self)
    }
    // MARK: 계산
    func calculate() {
        var totalPrice = 0
        var totalCount = 0
        for data in cartData {
            guard let initPrice = data.wishItem?.item_price else {return}
            guard let count = data.cartItemInfo?.item_count else {return}
            
            totalPrice = totalPrice + Int(initPrice)! * count
            totalCount = totalCount + count
        }
        self.price.text = FormatManager().strToPrice(numStr: String(totalPrice))
        self.countLabel.text = String(totalCount)
    }
}
// MARK: - API Success
extension CartView {
    // MARK: Cart 조회 API
    func getCartListAPISuccess(_ result: [CartListModel]) {
        self.cartData = result
        // reload data with animation
        UIView.transition(with: cartTableView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { () -> Void in
                                    self.cartTableView.reloadData()},
                                completion: nil);
        calculate()
    }
    func getCartListAPIFail() {
        CartDataManager().getCartListDataManager(self)
    }
    // MARK: 장바구니 수량 변경 API
    func modifyCountAPISuccess(_ result: APIModel<ResultModel>) {
        CartDataManager().getCartListDataManager(self)
        print(result.message)
    }
    // MARK: 장바구니 삭제 API
    func deleteCartAPISuccess(_ result: APIModel<ResultModel>) {
        CartDataManager().getCartListDataManager(self)
        print(result.message)
    }
}
// MARK: - CartGesture
class CartGesture: UITapGestureRecognizer {
    var cartItem: CartListModel?
}
