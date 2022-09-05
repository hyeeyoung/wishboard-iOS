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
    
    let onBoardingTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
 
        onBoardingTableView.delegate = self
        onBoardingTableView.dataSource = self
        onBoardingTableView.register(OnBoardingTableViewCell.self, forCellReuseIdentifier: "OnBoardingTableViewCell")

        setUpConstraint()

        // autoHeight
        onBoardingTableView.rowHeight = UITableView.automaticDimension
        onBoardingTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func setUpConstraint() {
        addSubview(onBoardingTableView)
        onBoardingTableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
