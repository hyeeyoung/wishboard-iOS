//
//  FolderCollectionViewCell.swift
//  Share Extension
//
//  Created by gomin on 2022/09/25.
//

import UIKit

class FolderCollectionViewCell: UICollectionViewCell {
    static let identifier = "FolderCollectionViewCell"
    
    let folderImage = UIImageView().then{
        $0.backgroundColor = .lightGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    let folderBackground = UIView().then{
        $0.backgroundColor = .notificationGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    let folderName = UILabel().then{
        $0.text = "folderName"
        $0.textColor = .white
        $0.font = UIFont.Suit(size: 11, family: .Bold)
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    let selectedView = UIView().then{
        $0.backgroundColor = .folderSelectedBackground
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    let selectedIcon = UIImageView().then{
        $0.image = UIImage(named: "check_white")
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
    override func prepareForReuse() {
        super.prepareForReuse()

        folderImage.image = nil
        folderName.text = nil
    }
    // MARK: - Functions
    func setUpView() {
        contentView.addSubview(folderImage)
        folderImage.addSubview(folderBackground)
        
        contentView.addSubview(selectedView)
        contentView.addSubview(folderName)
        contentView.addSubview(selectedIcon)
    }
    func setUpConstraint() {
        folderImage.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        folderBackground.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(folderImage)
        }
        folderName.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-6)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(3)
        }
        selectedView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        selectedIcon.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func setUpData(_ data: FolderListModel) {
        if let image = data.folder_thumbnail {
            self.folderImage.kf.setImage(with: URL(string: image), placeholder: UIImage())
        }
        if let name = data.folder_name {self.folderName.text = name}
    }
    func setSelectedFolder(_ isSelected: Bool) {
        if isSelected {
            self.selectedView.isHidden = false
            self.selectedIcon.isHidden = false
        } else {
            self.selectedView.isHidden = true
            self.selectedIcon.isHidden = true
        }
    }
}
