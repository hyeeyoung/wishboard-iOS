//
//  CartViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class CartViewController: TitleCenterViewController, Observer {
    var observer = WishListObserver.shared
    var cartView: CartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = "장바구니"
        self.tabBarController?.tabBar.isHidden = true
        
        cartView = CartView()
        self.view.addSubview(cartView)
        
        cartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        cartView.preVC = self
        
        observer.bind(self)
        
        // DATA
        CartDataManager().getCartListDataManager(self.cartView)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    func update(_ newValue: Any) {
        // DATA
        CartDataManager().getCartListDataManager(self.cartView)
    }
}
