//
//  MypageProfileTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class MypageProfileTableViewCell: UITableViewCell {
    // MARK: - View
    let profileView = UIView().then{
        $0.layer.cornerRadius = 32
        $0.backgroundColor = .black
    }
    let profileImage = UIButton().then{
        $0.setImage(UIImage(named: "defaultProfile"), for: .normal)
        $0.layer.cornerRadius = 45
    }
    let cameraButton = UIButton().then{
        $0.setImage(UIImage(named: "camera_green"), for: .normal)
    }
    let userNameLabel = UILabel().then{
        $0.text = "userName"
        $0.font = UIFont.Suit(size: 18, family: .Bold)
        $0.textColor = .white
    }
    let emailLabel = UILabel().then{
        $0.text = "email@email.com"
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textColor = .lightGray
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
        contentView.addSubview(profileView)
        profileView.addSubview(profileImage)
        profileView.addSubview(cameraButton)
        profileView.addSubview(userNameLabel)
        profileView.addSubview(emailLabel)
    }
    func setUpConstraint() {
        profileView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(90)
            make.top.equalToSuperview().offset(20)
        }
        cameraButton.snp.makeConstraints { make in
            make.width.equalTo(23)
            make.height.equalTo(22)
            make.trailing.bottom.equalTo(profileImage)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
