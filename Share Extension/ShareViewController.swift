//
//  ShareViewController.swift
//  Share Extension
//
//  Created by gomin on 2022/09/25.
//

import UIKit
import Social
import SnapKit
import Then
import MaterialComponents.MaterialBottomSheet

class ShareViewController: UIViewController {
    
    //MARK: - Properties
    let itemImage = UIImageView().then{
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 40
    }
    let backgroundView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    lazy var quitButton = UIButton().then{
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    let itemName = UILabel().then{
        $0.text = "itemName"
        $0.font = UIFont.Suit(size: 12, family: .Regular)
    }
    let itemPrice = UILabel().then{
        $0.text = "0000"
        $0.font = .systemFont(ofSize: 12, weight: .bold)
    }
    var setNotificationButton = UIButton().then{
        $0.setNotificationButton("", false)
    }
    let addFolderButton = UIButton().then{
        $0.setImage(UIImage(named: "addFolder"), for: .normal)
    }
    let completeButton = UIButton().then{
        $0.defaultButton("위시리스트에 추가", .wishboardGreen, .black)
    }
    //MARK: - Life Cycles
    var folderCollectionView: UICollectionView!
    var notivc: NotificationSettingViewController!
    var newFoldervc: NewFolderViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

//        let defaults = UserDefaults(suiteName: "group.gomin.Wishboard.Share")
//        defaults?.set("sss", forKey: "share")
//        defaults?.synchronize()
        
        self.view.backgroundColor = .clear
        
        setUpCollectionView()
        setUpView()
        setUpConstraint()
        
        notivc = NotificationSettingViewController()
        newFoldervc = NewFolderViewController()
        
        self.quitButton.addTarget(self, action: #selector(quit), for: .touchUpInside)
        self.completeButton.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
        self.setNotificationButton.addTarget(self, action: #selector(showNotificationBottomSheet), for: .touchUpInside)
        self.addFolderButton.addTarget(self, action: #selector(showAddNewFolderBottomSheet), for: .touchUpInside)
    }
    // MARK: - Actions
    @objc func quit() {
        print("clicked!!")
        self.dismiss(animated: true)
        
    }
    @objc func completeButtonDidTap() {
        let lottieView = completeButton.setHorizontalLottieView(completeButton)
        completeButton.isSelected = true
        lottieView.isHidden = false
        lottieView.loopMode = .repeat(2) // 2번 반복
        lottieView.play { completion in
            self.dismiss(animated: true)
//            SnackBar(self, message: .modifyItem)
        }
    }
    // 알람 설정 BottomSheet
    @objc func showNotificationBottomSheet() {
        notivc.setPreViewController(self)
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: notivc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 317
        bottomSheet.dismissOnDraggingDownSheet = false
        
        self.present(bottomSheet, animated: true, completion: nil)
    }
    // 새 폴더 추가 BottomSheet
    @objc func showAddNewFolderBottomSheet() {
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: newFoldervc)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 317
        bottomSheet.dismissOnDraggingDownSheet = false
        
        self.present(bottomSheet, animated: true, completion: nil)
    }
    //MARK: - Functions
    func setUpCollectionView() {
        folderCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 10
            
            
            flowLayout.itemSize = CGSize(width: 80, height: 80)
            flowLayout.scrollDirection = .horizontal
            
            $0.collectionViewLayout = flowLayout
            $0.dataSource = self
            $0.delegate = self
            $0.showsHorizontalScrollIndicator = false
            
            $0.register(FolderCollectionViewCell.self, forCellWithReuseIdentifier: FolderCollectionViewCell.identifier)
        }
    }
    func setUpView() {
        self.view.addSubview(backgroundView)
        backgroundView.addSubview(quitButton)
        backgroundView.addSubview(itemName)
        backgroundView.addSubview(itemPrice)
        backgroundView.addSubview(setNotificationButton)
        backgroundView.addSubview(addFolderButton)
        backgroundView.addSubview(folderCollectionView)
        backgroundView.addSubview(completeButton)
        
        self.view.addSubview(itemImage)
    }
    func setUpConstraint() {
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(317)
        }
        quitButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(12)
        }
        itemName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        itemPrice.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(itemName.snp.bottom).offset(2)
        }
        setNotificationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(itemPrice.snp.bottom).offset(12)
        }
        addFolderButton.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(setNotificationButton.snp.bottom).offset(15)
        }
        folderCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(addFolderButton.snp.trailing).offset(10)
            make.top.bottom.equalTo(addFolderButton)
            make.trailing.equalToSuperview()
        }
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-34)
        }
        
        itemImage.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backgroundView.snp.top)
        }
    }
}
// MARK: - CollectionView delegate
extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let count = wishListData.count ?? 0
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCollectionViewCell.identifier,
                                                            for: indexPath)
                as? FolderCollectionViewCell else{ fatalError() }
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 10
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let itemDetailVC = ItemDetailViewController()
//        itemDetailVC.modalPresentationStyle = .fullScreen
//        self.present(itemDetailVC, animated: true, completion: nil)
    }
    
    func setTempData() {
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item1", itemPrice: 1000, isCart: true))
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item2", itemPrice: 2000, isCart: false))
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item3", itemPrice: 3000, isCart: false))
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item4", itemPrice: 4000, isCart: true))
//        self.wishListData.append(WishListModel(itemImage: "", itemName: "item5", itemPrice: 5000, isCart: true))
    }
}
