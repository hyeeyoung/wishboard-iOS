//
//  CalenderViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class CalenderViewController: UIViewController {
    var calenderView: CalenderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        calenderView = CalenderView()
        self.view.addSubview(calenderView)
        
        calenderView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }

}
