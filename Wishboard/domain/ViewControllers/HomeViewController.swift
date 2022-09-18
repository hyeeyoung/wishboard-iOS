//
//  HomeViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class HomeViewController: UIViewController {
    var homeView: HomeView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        homeView = HomeView()
        self.view.addSubview(homeView)
        homeView.setViewController(self)
        
        homeView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        // temp data
        homeView.showBottomSheet()
        homeView.setTempData()
        self.homeView.cartButton.addTarget(self, action: #selector(goToCart), for: .touchUpInside)
    }
    @objc func goToCart() {
        let cartVC = CartViewController()
        cartVC.modalPresentationStyle = .fullScreen
        self.present(cartVC, animated: true, completion: nil)
    }
}
