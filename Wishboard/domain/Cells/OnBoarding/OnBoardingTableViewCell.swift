//
//  OnBoardingTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import UIKit
import Then
import SnapKit

class OnBoardingTableViewCell: UITableViewCell {

    // 흔드는 손 Image
    let handImage = UIImageView().then{
        $0.image = UIImage(named: "twemoji_waving-hand")
    }
    // Wish Board Logo Image
    let logoImage = UIImageView().then{
        $0.image = UIImage(named: "WishBoardLogo")
    }
    // Onbarding label
    let onboardingLabel = UILabel().then{
        $0.text = "흩어져있는 위시리스트를 위시보드로 간편하게 통합 관리해 보세요!️"
        $0.font = UIFont.Suit()
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    // 가입하기 버튼
    let registerButton = UIButton().then{
        $0.defaultButton("가입하기", .wishboardGreen, .black)
    }
    let loginStackView = UIStackView()
    // 이미 계정이 있으신가요?
    let accountExistLabel = UILabel().then{
        $0.text = "이미 계정이 있으신가요?"
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.numberOfLines = 0
    }
    // 로그인
    let loginButton = UIButton().then{
        $0.setUnderline("로그인", .wishboardGreen)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpView()
        setUpConstraint()
    }
    func setUpView() {
        contentView.addSubview(handImage)
        contentView.addSubview(logoImage)
        contentView.addSubview(onboardingLabel)
        
        contentView.addSubview(loginStackView)
        loginStackView.addSubview(accountExistLabel)
        loginStackView.addSubview(loginButton)
        contentView.addSubview(registerButton)
    }
    func setUpConstraint() {
        self.handImage.snp.makeConstraints { make in
            make.width.height.equalTo(72)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
        self.logoImage.snp.makeConstraints { make in
            make.width.equalTo(192)
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalTo(handImage.snp.bottom).offset(24)
        }
        self.onboardingLabel.snp.makeConstraints { make in
            make.width.equalTo(226)
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImage.snp.bottom).offset(18)
        }
        
        self.loginStackView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-34)
        }
        self.accountExistLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.bottom.leading.equalToSuperview()
        }
        self.loginButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(accountExistLabel.snp.trailing).offset(5)
        }
        self.registerButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(loginStackView.snp.top).offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
