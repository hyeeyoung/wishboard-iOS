//
//  MyPageViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit
import MessageUI
import RxSwift

class MyPageViewController: TitleLeftViewController, Observer {
    var observer = UserObserver.shared
    var viewModel = MyPageViewModel()
    
    var mypageView: MyPageView!
    let settingArray = ["", "알림 설정", "비밀번호 변경", "", "문의하기", "위시보드 이용 방법", "이용약관", "개인정보 처리방침", "오픈소스 라이브러리", "버전 정보", "", "로그아웃", "탈퇴하기"]

    var userInfoData: GetUserInfoModel!
    var nickName: String?
    var pushState: Bool?
    
    var notiSwitch: UISwitch = UISwitch()
    
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
        
        /// ViewModel bind
        bind()
        
        /// Observer init
        observer.bind(self)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    /// Observer
    func update(_ newValue: Any) {
        // 어떤 값을 전달받든 TabBar 는 visible
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        guard let usecase = newValue as? ObserverUseCase else {return}
        do {
            // 프로필이 수정된 경우와 비밀번호가 수정된 경우 분기처리
            if usecase == .profileModified {
                SnackBar.shared.showSnackBar(self, message: .modifyProfile)
                // reload profile Data
                MypageDataManager().getUserInfoDataManager(self)
            } else if usecase == .passwordModified {
                SnackBar.shared.showSnackBar(self, message: .modifyPassword)
            }
        }
    }
    
    func bind() {
        let input = MyPageViewModel.Input(notiSwitchObservable: notiSwitch.rx.isOn.asObservable())
        let output = viewModel.transform(input)
        
        output.getUserInfoResponse
            .drive(onNext: { [weak self] userInfo in
                // 사용자 정보를 화면에 출력
                self?.getUserInfoAPISuccess2(userInfo)
            })
            .disposed(by: disposeBag)

        output.setNotificationResponse
            .drive { [weak self] _ in
                UIDevice.vibrate()
                self?.pushState?.toggle()
            }
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
            self.setSwitchUI(cell)
        case 10:
            cell.textLabel?.text = settingArray[tag - 1]
            self.setVersionLabel(cell)
        default:
            cell.textLabel?.text = settingArray[tag - 1]
        }
        
        cell.textLabel?.setTypoStyleWithSingleLine(typoStyle: .SuitD1)
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
            
            self.moveToWebVC(Storage().howToUseLink, "위시보드 이용 방법")
        case 7:
            // 이용약관
            UIDevice.vibrate()
            
            self.moveToWebVC(Storage().useTermURL, "이용약관")
        case 8:
            // 개인정보처리방침
            UIDevice.vibrate()
            
            self.moveToWebVC(Storage().privacyTermURL, "개인정보 처리방침")
        case 9:
            // 오픈소스 라이브러리
            UIDevice.vibrate()
            
            self.moveToWebVC(Storage().openSourceLibraryURL, "오픈소스 라이브러리")
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 알림 설정 - Switch 넣기
    func setSwitchUI(_ cell: UITableViewCell) {
        // Switch 기본 크기: 가로51, 세로31
        notiSwitch.do{
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
        
    }
    
    // 버전 정보 표시 (1.2.0)
    func setVersionLabel(_ cell: UITableViewCell) {
        var appVersionStr: String = UserManager.appVersion ?? ""
        
        // 디버그 모드일 때에만 빌드버전 노출
        #if DEBUG
        appVersionStr += "(\(UserManager.appBuildVersion ?? ""))"
        #endif
        
        let versionLabel = UILabel().then{
            $0.text = appVersionStr
            $0.setTypoStyleWithSingleLine(typoStyle: .MontserratB1)
            $0.textColor = .gray_300
        }
        cell.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    // 로그아웃 팝업창
    func showLogoutDialog() {
        let model = PopUpModel(title: "로그아웃",
                               message: "정말 로그아웃 하시겠어요?",
                               greenBtnText: "취소",
                               blackBtnText: "로그아웃")
        let dialog = PopUpViewController(model)
        self.present(dialog, animated: false, completion: nil)
        
        // 로그아웃 확인 버튼 클릭 이벤트
        dialog.okBtn.rx.tap
            .flatMap { [weak self] _ -> Observable<Void> in
                return Observable.create { observer in
                    self?.logoutButtonDidTap()
                    self?.viewModel.callLogoutAPI()
                    self?.logoutAPISuccess()
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
        
    }
    // 회원 탈퇴 팝업창
    func showSignoutDialog() {
        let email = userInfoData.email
        let dialog = PopUpDeleteUserViewController(titleText: "회원 탈퇴", greenBtnText: "취소", blackBtnText: "탈퇴", placeholder: Placeholder.email, email: email)
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
    }
    /// 로그아웃 버튼 클릭 시 UI 이벤트
    func logoutButtonDidTap() {
        self.dismiss(animated: false)
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
            
            let deviceModel = UserManager.deviceModel
            let osVersion = UserManager.OSVersion
            let appVersion = UserManager.appVersion
            
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
    }
    func getUserInfoAPISuccess2(_ result: GetUserInfoModel?) {
        guard let result = result else {return}
        self.userInfoData = result
        self.nickName = self.userInfoData.nickname
        
        pushState = userInfoData.push_state == 1
        
        // reload data with animation
        UIView.transition(with: mypageView.mypageTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                              self.mypageView.mypageTableView.reloadData()},
                          completion: nil);
    }
    func getUserInfoAPIFail() {
        MypageDataManager().getUserInfoDataManager(self)
    }
    
    // MARK: 로그아웃 API
    func logoutAPISuccess() {
        // 사용자 데이터 삭제
        UserManager.removeUserData()
        // 첫화면으로 전환
        let navigationController = UINavigationController(rootViewController: OnBoardingViewController())
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(navigationController, animated: true)
        
    }
}

