//
//  TitleLeftViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/10/02.
//

import UIKit

class TitleLeftViewController: UIViewController {
    // MARK: - Properties
    // MARK: Init
    // 기본 초기화
    init(){
        super.init(nibName: nil, bundle: nil)
        self.viewDidLoad()
    }
    // 상단 오른쪽 버튼 설정
    init(btnImage: UIImage){
        super.init(nibName: nil, bundle: nil)
        self.viewDidLoad()
        self.rightPositionBtn = EtcButton(image: btnImage)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: Views
    let navigationView = UIView()
    
    lazy var navigationTitle = UILabel().then{
        $0.font = UIFont.Suit(size: 22, family: .Bold)
        $0.textColor = .black
    }
    
    lazy var rightPositionBtn: EtcButton? = nil{
        didSet{
            setRightPositionBtn()
        }
    }
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        //setUpView
        self.view.addSubview(navigationView)
        navigationView.addSubview(navigationTitle)
        
        //setUpConstraint
        navigationView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        navigationTitle.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.isNavigationBarHidden = true
    }
    // MARK: - Actions & Functions
    @objc func rightPositionBtnDidClicked(){
        print("right position btn did clicked")
    }
    
    func setRightPositionBtn(){
        guard let rightPositionBtn = rightPositionBtn else {return}
        
        navigationView.addSubview(rightPositionBtn)
        rightPositionBtn.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(rightPositionBtn.snp.height)
        }
        rightPositionBtn.addTarget(self, action: #selector(rightPositionBtnDidClicked), for: .touchUpInside)
    }
}
