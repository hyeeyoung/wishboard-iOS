//
//  ShareView.swift
//  Share Extension
//
//  Created by gomin on 2022/09/26.
//

import Foundation
import UIKit

class ShareView: UIView {
    //MARK: - Properties
    let itemImage = UIImageView().then{
        $0.backgroundColor = .systemGray6
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
        $0.image = Image.blackLogo
        $0.contentMode = .scaleAspectFill
    }
    let backgroundView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    lazy var quitButton = UIButton().then{
        $0.setImage(Image.quit, for: .normal)
    }
    let itemNameTextField = UITextField().then{
        $0.borderStyle = .none
        $0.font = TypoStyle.SuitD2.font
        $0.textAlignment = .center
        $0.placeholder = Placeholder.shareItemName
    }
    let itemPriceTextField = UITextField().then{
        $0.borderStyle = .none
        $0.font = TypoStyle.MontserratB1.font
        $0.keyboardType = .numberPad
        $0.textAlignment = .center
        $0.placeholder = Placeholder.shareItemPrice
    }
    var setNotificationButton = UIButton().then{
        $0.setNotificationButton("", false)
    }
    let addFolderButton = UIButton().then{
        $0.setImage(Image.addFolder, for: .normal)
    }
    let completeButton = DefaultButton(titleStr: Button.addToWishList).then{
        $0.isActivate = true
    }
    //MARK: - Life Cycles
    var folderCollectionView: UICollectionView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setUpCollectionView(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate) {
        folderCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 10
            
            
            flowLayout.itemSize = CGSize(width: 80, height: 80)
            flowLayout.scrollDirection = .horizontal
            
            $0.collectionViewLayout = flowLayout
            $0.dataSource = dataSourceDelegate
            $0.delegate = dataSourceDelegate
            $0.showsHorizontalScrollIndicator = false
            
            $0.register(FolderCollectionViewCell.self, forCellWithReuseIdentifier: FolderCollectionViewCell.identifier)
        }
    }
    func setUpView() {
        addSubview(backgroundView)
        backgroundView.addSubview(quitButton)
        backgroundView.addSubview(itemNameTextField)
        backgroundView.addSubview(itemPriceTextField)
        backgroundView.addSubview(setNotificationButton)
        backgroundView.addSubview(addFolderButton)
        backgroundView.addSubview(folderCollectionView)
        backgroundView.addSubview(completeButton)
        
        addSubview(itemImage)
    }
    func setUpConstraint() {
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(317)
        }
        quitButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(12)
        }
        itemNameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(50)
        }
        itemPriceTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(itemNameTextField.snp.bottom).offset(2)
        }
        setNotificationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(itemPriceTextField.snp.bottom).offset(12)
        }
        addFolderButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(setNotificationButton.snp.bottom).offset(15)
        }
        folderCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(addFolderButton.snp.trailing).offset(10)
            make.top.bottom.equalTo(addFolderButton)
            make.trailing.equalToSuperview()
        }
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-34)
        }
        
        itemImage.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backgroundView.snp.top)
        }
    }
}
