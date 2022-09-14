//
//  CalenderNotiTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class CalenderNotiTableViewCell: UITableViewCell {
    // MARK: - Views
    let label = UILabel().then{
        $0.text = "_월 _일 일정"
        $0.font = UIFont.Suit(size: 14, family: .Bold)
    }
    
    //MARK: - Life Cycles
    var noticeTableView: UITableView!
    var selectedDate: String!
    var notiData: [NotiData] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpTableView()
        setUpView()
        setUpConstraint()
        
        // temp data
        setTempData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setSelectedDate(_ date: String) {
        self.label.text = date + " 일정"
    }
    func setUpTableView() {
        noticeTableView = UITableView().then{
            $0.delegate = self
            $0.dataSource = self
            $0.register(NotiTableViewCell.self, forCellReuseIdentifier: "NotiTableViewCell")
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
    }
    func setUpView() {
        contentView.addSubview(label)
        contentView.addSubview(noticeTableView)
    }
    func setUpConstraint() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(16)
        }
        noticeTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(label.snp.bottom).offset(13)
            make.bottom.equalToSuperview()
        }
    }
}
// MARK: - TableView delegate
extension CalenderNotiTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = notiData.count ?? 0
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotiTableViewCell", for: indexPath) as? NotiTableViewCell else { return UITableViewCell() }
        let itemIdx = indexPath.item
        cell.setUpData(self.notiData[itemIdx])

        cell.setCalenderNotiCell()
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// temp data
extension CalenderNotiTableViewCell {
    func setTempData() {
        self.notiData.append(NotiData(itemImage: "", itemName: "item1", time: "1주 전", isViewed: false))
        self.notiData.append(NotiData(itemImage: "", itemName: "item2", time: "2주 전", isViewed: true))
        self.noticeTableView.reloadData()
    }
}
