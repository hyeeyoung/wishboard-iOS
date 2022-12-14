//
//  CartViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class CartViewController: TitleCenterViewController {
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
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        // DATA
        CartDataManager().getCartListDataManager(self.cartView)
        // Network Check
        NetworkCheck.shared.startMonitoring(vc: self)
    }
}
