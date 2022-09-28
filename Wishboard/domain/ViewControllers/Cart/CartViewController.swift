//
//  CartViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class CartViewController: UIViewController {
    var cartView: CartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        cartView = CartView()
        self.view.addSubview(cartView)
        
        cartView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.cartView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        // DATA
        CartDataManager().getCartListDataManager(self.cartView)
    }
    override func viewDidAppear(_ animated: Bool) {
        // DATA
        CartDataManager().getCartListDataManager(self.cartView)
    }
    @objc func goBack() {
        self.dismiss(animated: true)
    }
}
