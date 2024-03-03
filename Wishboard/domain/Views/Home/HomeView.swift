//
//  HomeView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import Foundation
import UIKit
import SnapKit
import Then
import MaterialComponents.MaterialBottomSheet

class HomeView: UIView {
    // MARK: - Properties
    // Navigation Views
    
    /// 이벤트뷰와 네비게이션 뷰가 있는 Stack
    let navigationViewStack = UIStackView().then {
        $0.axis = .vertical
    }
    let eventView = UIView().then {
        $0.backgroundColor = .gray_700
        $0.isUserInteractionEnabled = true
        $0.isHidden = true
    }
    let eventLabel = UILabel().then {
        $0.text = "위시보드 설문조사 참여하고 기프티콘 받으세요! 🤍 "
        $0.textColor = .white
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD2)
    }
    let eventQuitButton = UIButton().then {
        $0.setImage(Image.whiteQuit, for: .normal)
    }
    let navigationView = UIView()
    
    let logo = UIImageView().then{
        $0.image = Image.wishboardLogo
    }
    let cartButton = UIButton().then{
        $0.setImage(Image.cartIcon, for: .normal)
    }
    let calenderButton = UIButton().then{
        $0.setImage(Image.calender, for: .normal)
    }
    
    // MARK: - Life Cycles
    var collectionView : UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCollectionView()
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()) .then{
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width / 2
            
            flowLayout.itemSize = CGSize(width: width, height: 260)
            flowLayout.scrollDirection = .vertical
            
            $0.collectionViewLayout = flowLayout
            $0.showsVerticalScrollIndicator = false
            
            $0.register(WishListCollectionViewCell.self, forCellWithReuseIdentifier: WishListCollectionViewCell.identifier)
        }
    }
    func setUpView() {
        addSubview(navigationViewStack)
        navigationViewStack.addArrangedSubview(eventView)
        navigationViewStack.addArrangedSubview(navigationView)
        
        eventView.addSubview(eventLabel)
        eventView.addSubview(eventQuitButton)
        
        navigationView.addSubview(logo)
        navigationView.addSubview(calenderButton)
        navigationView.addSubview(cartButton)

        addSubview(collectionView)
    }
    func setUpNavigationConstraint() {
        navigationViewStack.snp.makeConstraints { make in
            if UIDevice.current.hasNotch {make.top.equalToSuperview().offset(50)}
            else {make.top.equalToSuperview().offset(20)}
            make.leading.trailing.equalToSuperview()
        }
        eventView.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        eventQuitButton.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.trailing.equalToSuperview().offset(-13)
            make.centerY.equalToSuperview()
        }
        eventLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(eventQuitButton.snp.leading).offset(-16)
        }
        navigationView.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        logo.snp.makeConstraints { make in
            make.width.equalTo(136.13)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        calenderButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        cartButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(calenderButton.snp.leading).offset(-16)
        }
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }
    }
}

// MARK: - CartGesture
class HomeCartGesture: UITapGestureRecognizer {
    var data: WishListModel?
}
