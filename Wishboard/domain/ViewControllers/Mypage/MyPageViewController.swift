//
//  MyPageViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class MyPageViewController: TitleLeftViewController {
    var mypageView: MyPageView!
    let settingArray = ["설정", "알림 설정", "고객 지원", "문의하기", "서비스 정보", "위시보드 이용 방법", "이용약관", "버전 정보", "계정 관리", "로그아웃", "회원 탈퇴"]

    var userInfoData: GetUserInfoModel!
    var nickName: String?
    var pushState: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = "마이페이지"
        
        mypageView = MyPageView()
        mypageView.setTableView(dataSourceDelegate: self)
        mypageView.setUpView()
        mypageView.setUpConstraint()
        self.view.addSubview(mypageView)
        
        mypageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        // DATA
        MypageDataManager().getUserInfoDataManager(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        // DATA
        MypageDataManager().getUserInfoDataManager(self)
    }
}
// MARK: - Main TableView delegate
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        if tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MypageProfileTableViewCell", for: indexPath) as? MypageProfileTableViewCell else { return UITableViewCell() }
            if let cellData = self.userInfoData {cell.setUpData(cellData)}
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = settingArray[tag - 1]
            if tag == 1 || tag == 3 || tag == 5 || tag == 9 {self.setTitleConstraint(cell)}
            else {
                cell.textLabel?.font = UIFont.Suit(size: 12, family: .Regular)
                cell.textLabel?.textColor = .black
                if tag == 2 {self.setSwitch(cell)}
                if tag == 8 {self.setVersionLabel(cell)}
            }
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tag = indexPath.row
        switch tag {
        case 0:
            return 184
        case 1, 3, 5, 9:
            return 62
        case 2:
            return 76
        default:
            return 40
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = indexPath.row
        switch tag {
        case 0:
            let vc = ModifyProfileViewController()
            if let nickname = self.userInfoData.nickname {
                vc.nameTextField.text = nickname
                vc.preNickName = self.userInfoData.nickname
            }
            if let profileImg = self.userInfoData.profile_img_url {
                vc.profileImage.kf.setImage(with: URL(string: profileImg), placeholder: UIImage())
                vc.preProfileImg = self.userInfoData.profile_img_url
            }
            vc.preVC = self
            self.navigationController?.pushViewController(vc, animated: true)
        case 10:
            showLogoutDialog()
        case 11:
            showSignoutDialog()
        case 6:
            ScreenManager().linkTo(viewcontroller: self, "https://hushed-bolt-fd4.notion.site/383c308f256f4f189b7c0b68a8f68d9f")
        case 7:
            ScreenManager().linkTo(viewcontroller: self, "https://www.wishboard.xyz/terms.html")
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: setting cell set & Functions
extension MyPageViewController {
    func setTitleConstraint(_ cell: UITableViewCell) {
        cell.textLabel!.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(16)
        }
        cell.textLabel?.font = UIFont.Suit(size: 15, family: .Bold)
        cell.selectionStyle = .none
    }
    // 알림 설정 - Switch 넣기
    func setSwitch(_ cell: UITableViewCell) {
        var notiSwitch = UISwitch().then{
            if let pushState = self.pushState {$0.isOn = pushState}
            else {$0.isOn = false}
            $0.onTintColor = .wishboardGreen
            $0.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
        let subTitleLabel = UILabel().then{
            $0.text = "알림 설정을 켜면 상품의 재입고, 프리오더 시작일 등 상품 일정을 알림 받을 수 있어요!"
            $0.font = UIFont.Suit(size: 8, family: .Regular)
            $0.textColor = .wishboardGray
        }
        cell.addSubview(notiSwitch)
        cell.addSubview(subTitleLabel)
        notiSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        notiSwitch.addTarget(self, action: #selector(onClickSwitch(_:)), for: UIControl.Event.valueChanged)
    }
    @objc func onClickSwitch(_ sender: UISwitch) {
        if sender.isOn {
            MypageDataManager().switchNotificationDataManager(true, self)
        } else {
            MypageDataManager().switchNotificationDataManager(false, self)
        }
    }
    // 버전 정보 표시 (1.0.0)
    func setVersionLabel(_ cell: UITableViewCell) {
        let versionLabel = UILabel().then{
            $0.text = "1.0.0"
            $0.font = UIFont.Suit(size: 12, family: .Bold)
            $0.textColor = .gray
        }
        cell.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    // 로그아웃 팝업창
    func showLogoutDialog() {
        let dialog = PopUpViewController(titleText: "로그아웃", messageText: "정말 로그아웃 하시겠어요?", greenBtnText: "취소", blackBtnText: "로그아웃")
        dialog.modalPresentationStyle = .overCurrentContext
        self.present(dialog, animated: false, completion: nil)
        
        dialog.okBtn.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
    }
    // 회원 탈퇴 팝업창
    func showSignoutDialog() {
        guard let email = self.userInfoData.email else {return}
        let dialog = PopUpDeleteUserViewController(titleText: "회원 탈퇴", messageText: "탈퇴하시면 회원정보는 7일 후 파기됩니다.", greenBtnText: "취소", blackBtnText: "탈퇴", placeholder: "이메일을 입력해주세요.", email: email)
        dialog.modalPresentationStyle = .overCurrentContext
        self.present(dialog, animated: false, completion: nil)
        
        dialog.okBtn.addTarget(self, action: #selector(signOutButtonDidTap), for: .touchUpInside)
    }
    @objc func logoutButtonDidTap() {
        self.dismiss(animated: false)
        MypageDataManager().logoutDataManager(self)
    }
    @objc func signOutButtonDidTap() {
        self.dismiss(animated: false)
        MypageDataManager().deleteUserDataManager(self)
    }
}
// MARK: - API Success
extension MyPageViewController {
    // MARK: 사용자 정보 조회 API
    func getUserInfoAPISuccess(_ result: [GetUserInfoModel]) {
        self.userInfoData = result[0]
        self.nickName = self.userInfoData.nickname
        switch self.userInfoData.push_state {
        case 1:
            self.pushState = true
        default:
            self.pushState = false
        }
        // reload data with animation
        UIView.transition(with: mypageView.mypageTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                              self.mypageView.mypageTableView.reloadData()},
                          completion: nil);
        print(result)
    }
    func getUserInfoAPIFail() {
        MypageDataManager().getUserInfoDataManager(self)
    }
    // MARK: 알림 토글 수정 API
    func switchNotificationAPISuccess(_ result: APIModel<ResultModel>) {
        pushState?.toggle()
        print(result.message)
    }
    // MARK: 회원 탈퇴 API
    func deleteUserAPISuccess(_ result: APIModel<ResultModel>) {
        // delete UserInfo
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "isFirstLogin")
        
        let onboardingVC = OnBoardingViewController()
        self.navigationController?.pushViewController(onboardingVC, animated: true)
        SnackBar(onboardingVC, message: .deleteUser)
        
        print(result.message)
    }
    // MARK: 로그아웃 API
    func logoutAPISuccess(_ result: APIModel<ResultModel>) {
        // delete UserInfo
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.set(false, forKey: "isFirstLogin")
        
        let onboardingVC = OnBoardingViewController()
        self.navigationController?.pushViewController(onboardingVC, animated: true)
        
        print(result.message)
    }
}

