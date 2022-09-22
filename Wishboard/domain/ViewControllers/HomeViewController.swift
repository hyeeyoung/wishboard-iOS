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
        
        homeView.showBottomSheet(self)
        // temp data
        homeView.setTempData()
        self.homeView.cartButton.addTarget(self, action: #selector(goToCart), for: .touchUpInside)
    }
    @objc func goToCart() {
        let cartVC = CartViewController()
        cartVC.modalPresentationStyle = .fullScreen
        self.present(cartVC, animated: true, completion: nil)
    }
    func alertDialog() {
        let dialog = PopUpViewController(titleText: "알림 허용", messageText: "알림을 받아보시겠어요?\n직접 등록하신 아이템의 재입고 날짜 등의 상품 일정 알림을 받으실 거에요.", greenBtnText: "나중에", blackBtnText: "허용")
        dialog.modalPresentationStyle = .overCurrentContext
        self.present(dialog, animated: false, completion: nil)
    }
}
