//
//  UploadItemTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/15.
//

import UIKit
import Kingfisher

class UploadItemPhotoTableViewCell: UITableViewCell {
    let photoImage = UIImageView().then{
        $0.backgroundColor = .wishboardTextfieldGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32
        $0.contentMode = .scaleAspectFit
    }
    let cameraImage = UIImageView().then{
        $0.image = UIImage(named: "camera_gray")
    }

    //MARK: - Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpView()
        setUpConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setUpView() {
        contentView.addSubview(photoImage)
        contentView.addSubview(cameraImage)
    }
    func setUpConstraint() {
        photoImage.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        cameraImage.snp.makeConstraints { make in
            make.width.equalTo(33)
            make.height.equalTo(28)
            make.centerY.centerX.equalTo(photoImage)
        }
    }
    func setUpImage(_ url: String) {
        self.photoImage.kf.setImage(with: URL(string: url), placeholder: UIImage())
        self.cameraImage.isHidden = true
    }
    func setUpImage(_ img: UIImage) {
        self.photoImage.image = img
        self.cameraImage.isHidden = true
    }
}
