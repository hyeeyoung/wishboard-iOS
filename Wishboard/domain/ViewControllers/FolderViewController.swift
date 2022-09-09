//
//  FolderViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class FolderViewController: UIViewController {
    var folderView : FolderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true

        folderView = FolderView()
        self.view.addSubview(folderView)
        
        folderView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    

}
