//
//  FolderCollectionViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class FolderCollectionViewCell: UICollectionViewCell {
    static let identifier = "FolderCollectionViewCell"
    
    let folderImage = UIImageView().then{
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 10
    }
    let folderType = UILabel().then{
        $0.text = "folder"
        $0.font = UIFont.Suit(size: 16, family: .Bold)
        $0.numberOfLines = 1
    }
    let countLabel = UILabel().then{
        $0.text = "0"
        $0.font = UIFont.Suit(size: 12.5, family: .Regular)
        $0.textColor = .lightGray
    }
    let itemLabel = UILabel().then{
        $0.text = "아이템"
        $0.font = UIFont.Suit(size: 12.5, family: .Regular)
        $0.textColor = .lightGray
    }
    let moreButton = UIButton().then{
        $0.setImage(UIImage(named: "ic_more"), for: .normal)
    }
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        contentView.addSubview(folderImage)
        contentView.addSubview(moreButton)
        contentView.addSubview(folderType)
        contentView.addSubview(countLabel)
        contentView.addSubview(itemLabel)
    }
    func setUpConstraint() {
        folderImage.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(folderImage.snp.width)
        }
        moreButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview()
            make.top.equalTo(folderImage.snp.bottom)
        }
        folderType.snp.makeConstraints { make in
            make.leading.equalTo(folderImage)
            make.top.equalTo(folderImage.snp.bottom).offset(10)
            make.trailing.equalTo(moreButton.snp.leading).offset(-10)
        }
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(folderType)
            make.top.equalTo(folderType.snp.bottom).offset(5)
        }
        itemLabel.snp.makeConstraints { make in
            make.centerY.equalTo(countLabel)
            make.leading.equalTo(countLabel.snp.trailing).offset(3)
        }
    }
}