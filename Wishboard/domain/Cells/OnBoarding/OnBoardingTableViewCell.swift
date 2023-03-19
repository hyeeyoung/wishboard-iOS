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
        $0.image = Image.wavingHand
    }
    // Wish Board Logo Image
    let logoImage = UIImageView().then{
        $0.image = Image.wishboardLogo
    }
    // Onbarding label
    let onboardingLabel = UILabel().then{
        $0.text = Message.onboarding
        $0.font = UIFont.Suit()
        $0.numberOfLines = 0
        $0.setTextWithLineHeight()
        $0.textAlignment = .center
    }
    // 가입하기 버튼
    lazy var registerButton = DefaultButton(titleStr: Button.register).then{
        $0.isActivate = true
    }
    let loginStackView = UIStackView()
    // 이미 계정이 있으신가요?
    let accountExistButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        var attText = AttributedString.init(Message.toLogin)
        
        attText.font = UIFont.Suit(size: 12, family: .Regular)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        attText.foregroundColor = UIColor.black
        config.attributedTitle = attText
        config.baseForegroundColor = .black
        
        $0.configuration = config
    }
    // 로그인
    let loginButton = UIButton().then{
        $0.setUnderline(Message.login, .wishboardGreen)
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
        loginStackView.addSubview(accountExistButton)
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
        self.accountExistButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.bottom.leading.equalToSuperview()
        }
        self.loginButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(accountExistButton.snp.trailing).offset(5)
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
