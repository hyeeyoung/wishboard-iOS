//
//  OnBoardingView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/05.
//

import Foundation
import SnapKit
import Then

class OnBoardingView: UIView {
    
    var onBoardingTableView: UITableView!
    var onBoardingViewModel: OnBoardingViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        onBoardingViewModel = OnBoardingViewModel()
        
        onBoardingTableView = UITableView()
        onBoardingTableView.delegate = self
        onBoardingTableView.dataSource = self
        onBoardingTableView.register(OnBoardingTableViewCell.self, forCellReuseIdentifier: "OnBoardingTableViewCell")

        setUpView()

        // autoHeight
        onBoardingTableView.rowHeight = UITableView.automaticDimension
        onBoardingTableView.estimatedRowHeight = UITableView.automaticDimension
        onBoardingTableView.separatorStyle = .none
        onBoardingTableView.showsVerticalScrollIndicator = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Functions
    func setViewController(_ viewcontroller: OnBoardingViewController) {
        onBoardingViewModel.setViewController(viewcontroller)
    }
    func setUpView() {
        addSubview(onBoardingTableView)
        onBoardingTableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    //MARK: Actions
    @objc func loginButtonDidTap(_ sender: UIButton) {
        UIDevice.vibrate()
        onBoardingViewModel.goToLoginPage()
    }
    @objc func registerButtonDidTap(_ sender: UIButton) {
        UIDevice.vibrate()
        onBoardingViewModel.goToRegisterPage()
    }
}
// MARK: - OnBoarding TableView delegate
extension OnBoardingView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OnBoardingTableViewCell", for: indexPath) as? OnBoardingTableViewCell else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.loginButton.addTarget(self, action: #selector(loginButtonDidTap(_:)), for: .touchUpInside)
        cell.accountExistButton.addTarget(self, action: #selector(loginButtonDidTap(_:)), for: .touchUpInside)
        cell.registerButton.addTarget(self, action: #selector(registerButtonDidTap(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height - 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
