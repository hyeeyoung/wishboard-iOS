//
//  MyPageViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit
import MessageUI

class MyPageViewController: TitleLeftViewController {
    var mypageView: MyPageView!
    let settingArray = ["", "알림 설정", "비밀번호 변경", "", "문의하기", "위시보드 이용 방법", "이용약관", "개인정보 처리방침", "오픈소스 라이브러리", "버전 정보", "", "로그아웃", "탈퇴하기"]

    var userInfoData: GetUserInfoModel!
    var nickName: String?
    var pushState: Bool?
    
    var isProfileModified: Bool = false
    var isPasswordModified: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = Title.mypage
        
        mypageView = MyPageView()
        mypageView.setTableView(dataSourceDelegate: self)
        mypageView.setUpView()
        mypageView.setUpConstraint()
        self.view.addSubview(mypageView)
        
        mypageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        // DATA
//        MypageDataManager().getUserInfoDataManager(self)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        // DATA
        MypageDataManager().getUserInfoDataManager(self)
        // Check if userdata modified
        checkIfUserdataModified()
    }
}
// MARK: - Main TableView delegate
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        
        let cell = UITableViewCell()
        
        switch tag {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MypageProfileTableViewCell", for: indexPath) as? MypageProfileTableViewCell else { return UITableViewCell() }
            if let cellData = self.userInfoData {cell.setUpData(cellData)}
            cell.modifyButton.addTarget(self, action: #selector(moveToModifyProfile), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        case 1, 4, 11:
            cell.backgroundColor = .gray_50
        case 2:
            cell.textLabel?.text = settingArray[tag - 1]
            self.setSwitch(cell)
        case 10:
            cell.textLabel?.text = settingArray[tag - 1]
            self.setVersionLabel(cell)
        default:
            cell.textLabel?.text = settingArray[tag - 1]
        }
        
        cell.textLabel?.font = UIFont.Suit(size: 16, family: .Regular)
        cell.textLabel?.textColor = .gray_600
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tag = indexPath.row
        switch tag {
        case 0:
            return 142
        case 1, 4, 11:
            return 6
        default:
            return 48
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = indexPath.row
        switch tag {
        case 0:
            UIDevice.vibrate()
        case 3:
            // 비밀번호 변경
            let vc = ModifyPasswordViewController()
            vc.preVC = self
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            // 문의하기
            UIDevice.vibrate()
            showSendEmail()
        case 12:
            // 로그아웃
            UIDevice.vibrate()
            showLogoutDialog()
        case 13:
            // 회원탈퇴
            UIDevice.vibrate()
            showSignoutDialog()
        case 6:
            // 위시보드 이용 방법
            UIDevice.vibrate()
            
            let link = "https://hushed-bolt-fd4.notion.site/383c308f256f4f189b7c0b68a8f68d9f"
            self.moveToWebVC(link, "위시보드 이용 방법")
        case 7:
            // 이용약관
            UIDevice.vibrate()
            
            let link = "https://www.wishboard.xyz/terms.html"
            self.moveToWebVC(link, "이용약관")
        case 8:
            // 개인정보처리방침
            UIDevice.vibrate()
            
            let link = "https://www.wishboard.xyz/privacy-policy.html"
            self.moveToWebVC(link, "개인정보 처리방침")
        case 9:
            // 오픈소스 라이브러리
            UIDevice.vibrate()
            
            let link = "https://www.wishboard.xyz/opensource.html"
            self.moveToWebVC(link, "오픈소스 라이브러리")
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: setting cell set & Functions
extension MyPageViewController {
    // 프로필 수정 페이지 이동
    @objc func moveToModifyProfile() {
        let vc = ModifyProfileViewController()
        if let nickname = self.nickName {
            vc.nameTextField.text = nickname
            vc.preNickName = self.userInfoData.nickname
        }
        if let profileImg = self.userInfoData.profile_img_url {
            vc.profileImage.kf.setImage(with: URL(string: profileImg), placeholder: UIImage())
            vc.preProfileImg = self.userInfoData.profile_img_url
        }
        vc.preVC = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 알림 설정 - Switch 넣기
    func setSwitch(_ cell: UITableViewCell) {
        // Switch 기본 크기: 가로51, 세로31
        var notiSwitch = UISwitch().then{
            if let pushState = self.pushState {$0.isOn = pushState}
            else {$0.isOn = false}
            $0.onTintColor = .green_500
            $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.75)
            $0.backgroundColor = UIColor.gray_300
            $0.layer.cornerRadius = 16.5
        }
        cell.addSubview(notiSwitch)
        notiSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        notiSwitch.addTarget(self, action: #selector(onClickSwitch(_:)), for: UIControl.Event.valueChanged)
    }
    @objc func onClickSwitch(_ sender: UISwitch) {
        UIDevice.vibrate()
        if sender.isOn {
            MypageDataManager().switchNotificationDataManager(true, self)
        } else {
            MypageDataManager().switchNotificationDataManager(false, self)
        }
    }
    // 버전 정보 표시 (1.0.0)
    func setVersionLabel(_ cell: UITableViewCell) {
        let appVersion = UserDefaults.standard.string(forKey: "appVersion") ?? ""
        let versionLabel = UILabel().then{
            $0.text = appVersion
            $0.font = UIFont.monteserrat(size: 14, family: .SemiBold)
            $0.textColor = .gray_300
            $0.setTextWithLineHeight()
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
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
        
        dialog.okBtn.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
    }
    // 회원 탈퇴 팝업창
    func showSignoutDialog() {
        guard let email = self.userInfoData.email else {return}
        let dialog = PopUpDeleteUserViewController(titleText: "회원 탈퇴", greenBtnText: "취소", blackBtnText: "탈퇴", placeholder: Placeholder.email, email: email)
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
        
        dialog.okBtn.addTarget(self, action: #selector(signOutButtonDidTap), for: .touchUpInside)
    }
    @objc func logoutButtonDidTap() {
        self.dismiss(animated: false)
        MypageDataManager().logoutDataManager(self)
        UIDevice.vibrate()
    }
    @objc func signOutButtonDidTap() {
        self.dismiss(animated: false)
        MypageDataManager().deleteUserDataManager(self)
        UIDevice.vibrate()
    }
}
// MARK: - Email delegate
extension MyPageViewController: MFMailComposeViewControllerDelegate {
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    func showSendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            
            let deviceModel = UserDefaults.standard.string(forKey: "deviceModel") ?? ""
            let osVersion = UserDefaults.standard.string(forKey: "OSVersion") ?? ""
            let appVersion = UserDefaults.standard.string(forKey: "appVersion") ?? ""
            
            let messageBody = "\nDevice: \(deviceModel)"
                                + "\nOS Version: \(osVersion)"
                                + "\nApp Version: \(appVersion)"
                                + "\n---------------------\n\n"
                                + "문의할 내용을 입력해 주세요."
            
            compseVC.setToRecipients(["wishboard2022@gmail.com"])
            compseVC.setSubject("위시보드팀에 문의하기")
            compseVC.setMessageBody(messageBody, isHTML: false)
            
            self.present(compseVC, animated: true, completion: nil)
            
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    // MARK: move to link
    func moveToWebVC(_ link: String, _ title: String) {
        let vc = WebViewController()
        vc.webURL = link
        vc.setUpTitle(title)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // Check if userdata modified
    func checkIfUserdataModified() {
        // 프로필이 변경되었을 때 스낵바 출력
        if isProfileModified {
            SnackBar(self, message: .modifyProfile)
            isProfileModified.toggle()
        }
        // 비밀번호 변경되었을 때 스낵바 출력
        if isPasswordModified {
            SnackBar(self, message: .modifyPassword)
            isPasswordModified.toggle()
        }
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
    func switchNotificationAPISuccess(_ result: APIModel<TokenResultModel>) {
        pushState?.toggle()
        print(result.message)
    }
    // MARK: 회원 탈퇴 API
    func deleteUserAPISuccess(_ result: APIModel<TokenResultModel>) {
        // delete UserInfo
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "isFirstLogin")
        UserDefaults(suiteName: "group.gomin.Wishboard.Share")?.removeObject(forKey: "accessToken")
        
        let onboardingVC = OnBoardingViewController()
        onboardingVC.deleteUser = true
        self.navigationController?.pushViewController(onboardingVC, animated: true)
        
        print(result.message)
    }
    // MARK: 로그아웃 API
    func logoutAPISuccess(_ result: APIModel<ResultModel>) {
        // delete UserInfo
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.set(false, forKey: "isFirstLogin")
        UserDefaults(suiteName: "group.gomin.Wishboard.Share")?.removeObject(forKey: "accessToken")
        
        let onboardingVC = OnBoardingViewController()
        self.navigationController?.pushViewController(onboardingVC, animated: true)
        
        print(result.message)
    }
}

