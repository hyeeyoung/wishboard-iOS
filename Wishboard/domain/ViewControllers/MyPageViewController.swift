//
//  MyPageViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class MyPageViewController: UIViewController {
    var mypageView: MyPageView!
    let settingArray = ["설정", "알림", "프로필 설정", "계정관리", "로그아웃", "탈퇴하기", "기타", "버전 정보", "이용약관", "자주 묻는 질문"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        mypageView = MyPageView()
        mypageView.setTableView(dataSourceDelegate: self)
        mypageView.setUpView()
        mypageView.setUpConstraint()
        self.view.addSubview(mypageView)
        
        mypageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    

}
// MARK: - Main TableView delegate
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        if tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MypageProfileTableViewCell", for: indexPath) as? MypageProfileTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = settingArray[tag - 1]
            if tag == 1 || tag == 4 || tag == 7 {self.setTitleConstraint(cell)}
            else {
                cell.textLabel?.font = UIFont.Suit(size: 12, family: .Regular)
                cell.textLabel?.textColor = .gray
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
        case 1, 4, 7:
            return 62
        default:
            return 40
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: setting cell set
extension MyPageViewController {
    func setTitleConstraint(_ cell: UITableViewCell) {
        cell.textLabel!.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(16)
        }
        cell.textLabel?.font = UIFont.Suit(size: 15, family: .Bold)
    }
    func setSwitch(_ cell: UITableViewCell) {
        let notiSwitch = UISwitch().then{
            $0.isOn = true
            $0.onTintColor = UIColor(named: "WishBoardColor")
        }
        cell.addSubview(notiSwitch)
        notiSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    func setVersionLabel(_ cell: UITableViewCell) {
        let versionLabel = UILabel().then{
            $0.text = "1.0.0"
            $0.font = UIFont.Suit(size: 12, family: .Regular)
            $0.textColor = .gray
        }
        cell.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
