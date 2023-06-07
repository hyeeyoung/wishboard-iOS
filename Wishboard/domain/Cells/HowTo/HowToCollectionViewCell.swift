//
//  HowToCollectionViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class HowToCollectionViewCell: UICollectionViewCell {
    static let identifier = "HowToCollectionViewCell"
    // MARK: - Properties
    let backGroundView = UIView().then{
        $0.backgroundColor = .EDEDED
    }
    let phoneImage = UIImageView()
    let title = DefaultLabel().then{
        $0.text = ""
        $0.font = UIFont.Suit(size: 22, family: .Bold)
    }
    let subTitle = DefaultLabel().then{
        $0.font = UIFont.Suit(size: 14, family: .Regular)
        $0.numberOfLines = 0
        $0.setTextWithLineHeight()
        $0.textAlignment = .center
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
    // MARK: - Functions
    func setUpView() {
        contentView.addSubview(backGroundView)
        contentView.addSubview(phoneImage)
        
        contentView.addSubview(title)
        contentView.addSubview(subTitle)
    }
    func setUpConstraint() {
        backGroundView.snp.makeConstraints { make in
            make.height.equalTo(411)
            make.leading.trailing.top.equalToSuperview()
        }
        phoneImage.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(backGroundView)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(backGroundView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        subTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(title.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    func setCellData(_ itemIdx: Int) {
        let howToUseImage = [Image.how1, Image.how2, Image.how3]
        let howToUseTitle = ["아이템 저장", "폴더 지정", "알림 설정"]
        let howToUseSubtitle = ["웹 브라우저에서 사고 싶은 아이템이 있다면\n“공유하기”를 통해 아이템을 위시보드에 저장해보세요!",
                        "아이템에 폴더를 지정해보세요!\n원하는 폴더가 없다면 새 폴더를 추가할 수 있어요.",
                        "상품의 재입고, 프리오더, 세일 알림을 설정해 보세요.\n설정한 시간 30분 전에 알림 보내드려요!"]
        self.title.text = howToUseTitle[itemIdx]
        self.subTitle.text = howToUseSubtitle[itemIdx]
        self.phoneImage.image = howToUseImage[itemIdx]
    }
}
