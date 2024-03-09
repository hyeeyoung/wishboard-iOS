//
//  HomeItem.swift
//  Wishboard
//
//  Created by gomin on 3/3/24.
//

import UIKit
import Kingfisher

protocol HomeItemDelegate: AnyObject {
    func cartButtonTap(withData data: HomeCartData)
}

struct HomeCartData {
    let cartState: Bool
    let itemId: Int
}

class HomeItem: UIView {
    
    // MARK: - UI
    private let itemImage = UIImageView().then{
        $0.backgroundColor = .black_5
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    private let itemName = DefaultLabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
        $0.numberOfLines = 1
    }
    private let itemPrice = DefaultLabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .MontserratH3)
    }
    private let won = DefaultLabel().then{
        $0.text = Item.won
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
    }
    private let cartButton = UIButton().then{
        $0.setCartButton(false)
    }
    
    // MARK: - Life Cycles
    var delegate: HomeItemDelegate?
    var homeCartData: HomeCartData?
    
    init(frame: CGRect, id: Int, imgUrl: String?, name: String, price: String, cartState: Bool) {
        super.init(frame: frame)
        
        self.setUpView()
        self.setUpConstraint()
        self.addTargets()
        
        self.configure(id, imgUrl, name, price, cartState)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func setUpView() {
        self.addSubview(itemImage)
        self.addSubview(itemName)
        self.addSubview(itemPrice)
        self.addSubview(won)
        self.addSubview(cartButton)
    }
    private func setUpConstraint() {
        itemImage.snp.makeConstraints { make in
            make.height.equalTo(itemImage.snp.width)
            make.leading.top.trailing.equalToSuperview()
        }
        itemName.snp.makeConstraints { make in
            make.top.equalTo(itemImage.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        itemPrice.snp.makeConstraints { make in
            make.top.equalTo(itemName.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(20)
        }
        won.snp.makeConstraints { make in
            make.centerY.equalTo(itemPrice)
            make.leading.equalTo(itemPrice.snp.trailing).offset(2)
        }
        cartButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.bottom.trailing.equalTo(itemImage).inset(10)
        }
    }
    
    private func addTargets() {
        self.cartButton.addTarget(self, action: #selector(cartButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func cartButtonDidTap(_ sender: UIButton) {
        guard let homeCartData = self.homeCartData else {return}
        self.delegate?.cartButtonTap(withData: homeCartData)
    }
    
    private func configure(_ id: Int, _ imgUrl: String?, _ name: String, _ price: String, _ cartState: Bool) {
        self.homeCartData = HomeCartData(cartState: cartState, itemId: id)
        
        self.itemName.text = name
        self.itemPrice.text = FormatManager().strToPrice(numStr: price)
        
        self.imgConfigure(imgUrl)
        self.cartConfigure(cartState)
    }
    
    private func imgConfigure(_ imgUrl: String?) {
        if let imgUrl = imgUrl {
            let processor = TintImageProcessor(tint: .black_5)
            self.itemImage.kf.setImage(with: URL(string: imgUrl), placeholder: UIImage(), options: [.processor(processor), .transition(.fade(0.5))])
        }
    }
    
    private func cartConfigure(_ cartState: Bool) {
        self.cartButton.setCartButton(cartState)
        self.cartButton.tag = cartState ? 1 : 0
    }
    
    func set(_ id: Int, _ imgUrl: String?, _ name: String, _ price: String, _ cartState: Bool) {
//        self.snp.makeConstraints { make in
//            make.horizontalEdges.verticalEdges.equalToSuperview()
//        }
        
        self.configure(id, imgUrl, name, price, cartState)
    }
}

