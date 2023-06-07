//
//  MypageProfileTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit
import Kingfisher

class MypageProfileTableViewCell: UITableViewCell {
    // MARK: - View
    let profileImage = UIImageView().then{
        $0.image = Image.defaultProfile
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
        $0.contentMode = .scaleAspectFill
    }
    let userNameLabel = UILabel().then{
        $0.font = UIFont.Suit(size: 18, family: .Bold)
        $0.textColor = .black
    }
    let emailLabel = UILabel().then{
        $0.text = ""
        $0.font = UIFont.Suit(size: 14, family: .Medium)
        $0.textColor = .lightGray
    }
    let modifyButton = UIButton().then{
        $0.setTitle("편집", for: .normal)
        $0.setTitleColor(UIColor.gray_600, for: .normal)
        $0.titleLabel?.font = UIFont.Suit(size: 14, family: .Medium)
        $0.backgroundColor = UIColor.gray_100
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
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
        contentView.addSubview(profileImage)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(modifyButton)
    }
    func setUpConstraint() {
        profileImage.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-48)
            make.top.equalToSuperview().offset(34)
            make.width.height.equalTo(60)
            make.leading.equalToSuperview().offset(16)
        }
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.top.equalToSuperview().offset(45)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(8)
            make.leading.equalTo(userNameLabel)
        }
        modifyButton.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(24)
            make.top.equalToSuperview().offset(52)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    func setUpData(_ data: GetUserInfoModel) {
        if let profileUrl = data.profile_img_url {
            profileImage.kf.setImage(with: URL(string: profileUrl), placeholder: Image.defaultProfile)
        }
        if let nickname = data.nickname {userNameLabel.text = nickname}
        else {userNameLabel.text = UserDefaults.standard.string(forKey: "tempNickname") ?? ""}
        if let email = data.email {emailLabel.text = email}
    }
}
