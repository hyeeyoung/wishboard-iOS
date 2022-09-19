//
//  FolderView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import Foundation
import UIKit

class FolderView: UIView {
    // MARK: - View
    let navigationView = UIView()
    let titleLabel = UILabel().then{
        $0.text = "폴더"
        $0.font = UIFont.Suit(size: 22, family: .Bold)
    }
    let plusButton = UIButton().then{
        $0.setImage(UIImage(named: "ic_new_folder"), for: .normal)
    }
    // MARK: - Life Cycles
    var folderCollectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollectionView(_ dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate) {
        folderCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()) .then{
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 16
            

            var bounds = UIScreen.main.bounds
            var width = bounds.size.width
            var itemWidth = ((width - 32) / 2) - 8
            
            flowLayout.itemSize = CGSize(width: itemWidth, height: 210)
            flowLayout.scrollDirection = .vertical
            
            $0.collectionViewLayout = flowLayout
            $0.dataSource = dataSourceDelegate
            $0.delegate = dataSourceDelegate
            $0.showsVerticalScrollIndicator = false
            
            $0.register(FolderCollectionViewCell.self, forCellWithReuseIdentifier: FolderCollectionViewCell.identifier)
        }
    }
    func setUpView() {
        addSubview(navigationView)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(plusButton)
        
        addSubview(folderCollectionView)
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        
        folderCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(navigationView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    func setUpNavigationConstraint() {
        navigationView.snp.makeConstraints { make in
            if CheckNotch().hasNotch() {make.top.equalToSuperview().offset(50)}
            else {make.top.equalToSuperview().offset(20)}
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
