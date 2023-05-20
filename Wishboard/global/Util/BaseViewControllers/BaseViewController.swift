//
//  BaseViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/10/01.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Properties
    // MARK: Init
    // 기본 초기화
    init(){
        super.init(nibName: nil, bundle: nil)
//        self.viewDidLoad()
    }
    // 제목 설정
    init(title: String){
        super.init(nibName: nil, bundle: nil)
//        self.viewDidLoad()
        self.rightPositionBtn = EtcButton(title: title)
    }
    // 상단 오른쪽 버튼 설정
    init(btnImage: UIImage){
        super.init(nibName: nil, bundle: nil)
//        self.viewDidLoad()
        self.rightPositionBtn = EtcButton(image: btnImage)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: Views
    let navigationView = UIView()
    
    lazy var backBtn = UIButton().then{
        $0.isUserInteractionEnabled = true
        $0.addTarget(self, action: #selector(backBtnDidClicked), for: .touchUpInside)
        
        var config = UIButton.Configuration.plain()
        config.image = Image.goBack
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    
    lazy var navigationTitle = UILabel().then{
        $0.font = UIFont.Suit(size: 14, family: .Bold)
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
                
        //setUpView
        self.view.addSubview(navigationView)
        
        //setUpConstraint
        navigationView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        NetworkCheck.shared.startMonitoring(vc: self)
    }
    // MARK: - Actions
    @objc func backBtnDidClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
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
// MARK: - Custom right button
class EtcButton: UIButton{
    init(title: String){
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.Suit(size: 14, family: .Regular)
        self.setTitleColor(.black, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 4, right: 0)
    }
    
    init(image: UIImage){
        super.init(frame: .zero)
        self.setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
