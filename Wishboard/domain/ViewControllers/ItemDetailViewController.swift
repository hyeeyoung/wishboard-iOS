//
//  ItemDetailViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class ItemDetailViewController: UIViewController {
    var itemDetailView: ItemDetailView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        itemDetailView = ItemDetailView()
        self.view.addSubview(itemDetailView)
        
        itemDetailView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    

}
