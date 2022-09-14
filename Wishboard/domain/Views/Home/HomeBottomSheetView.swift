//
//  HomeBottomSheetView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import Foundation
import UIKit

class HomeBottomSheetView: UIView {
    // MARK: - Properties
    let okButton = UIButton().then{
        $0.defaultButton("네! 알겠어요", .black, .white)
    }
    private let pageControl = UIPageControl().then{
        $0.hidesForSinglePage = true
        $0.numberOfPages = 3
        $0.currentPageIndicatorTintColor = .black
        $0.pageIndicatorTintColor = .lightGray
    }
    
    // MARK: - Life Cycles
    var howToCollectionView: UICollectionView!
    var howToUseTitle: [String]!
    var howToUseSubtitle: [String]!
    var howToUseImage: [String]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
        
        setCollectionView()
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setCollectionView() {
        howToCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()) .then{
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0

            let bounds = UIScreen.main.bounds
            let width = bounds.size.width
            
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            flowLayout.itemSize = CGSize(width: width, height: 555)
            flowLayout.scrollDirection = .horizontal
            
            $0.collectionViewLayout = flowLayout
            $0.dataSource = self
            $0.delegate = self
            
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            $0.register(HowToCollectionViewCell.self, forCellWithReuseIdentifier: HowToCollectionViewCell.identifier)
        }
        howToCollectionView.reloadData()
    }
    func setUpView() {
        addSubview(howToCollectionView)
        addSubview(okButton)
        addSubview(pageControl)
    }
    func setUpConstraint() {
        howToCollectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(590)
        }
        okButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(howToCollectionView.snp.bottom).offset(16)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(howToCollectionView)
            make.bottom.equalTo(howToCollectionView.snp.bottom)
        }
    }
}
// MARK: - CollectionView delegate
extension HomeBottomSheetView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HowToCollectionViewCell.identifier,
                                                            for: indexPath)
                as? HowToCollectionViewCell else{ fatalError() }
        let itemIdx = indexPath.item
        cell.setCellData(itemIdx)
        return cell
    }
    // collectionview indicator
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / scrollView.frame.width)
        self.pageControl.currentPage = page
    }
}
