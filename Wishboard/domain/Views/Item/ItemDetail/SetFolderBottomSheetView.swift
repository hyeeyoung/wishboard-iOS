//
//  SetFolderBottomSheetView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/14.
//

import Foundation
import UIKit

class SetFolderBottomSheetView: UIView {
    let titleLabel = DefaultLabel().then{
        $0.text = BottomSheetTitle.folderSetting
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitH3)
    }
    let exitBtn = UIButton().then{
        $0.setImage(Image.quit, for: .normal)
    }
    
    // MARK: - Life Cycles
    var folderTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
        
//        setTableView()
//        setUpView()
//        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setTableView(dataSourceDelegate: UITableViewDelegate & UITableViewDataSource) {
        folderTableView = UITableView().then{
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.register(FolderListTableViewCell.self, forCellReuseIdentifier: "FolderListTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
            $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        }
    }
    func setUpView() {
        addSubview(titleLabel)
        addSubview(exitBtn)
        addSubview(folderTableView)
    }
    func setUpConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        exitBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
        }
        folderTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
//            make.bottom.equalToSuperview()
            make.height.equalTo(317)
        }
    }
}
