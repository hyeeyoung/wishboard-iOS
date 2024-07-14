//
//  UploadItemTextViewCell.swift
//  Wishboard
//
//  Created by gomin on 2023/12/17.
//

import Foundation
import UIKit

class UploadItemTextViewCell: UITableViewCell {
    let memoTextView = UITextView().then{
        $0.font = TypoStyle.SuitB3.font
        $0.textColor = .gray_700
        $0.textAlignment = .left
        // TextField MainThread 버그를 위해 '수정제안' 제거 (24.05.18 / Xcode 15)
        $0.spellCheckingType = .no
        $0.autocorrectionType = .no
    }
    
    //MARK: - Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.contentView.addSubview(memoTextView)
        
        self.memoTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(11)
            make.height.greaterThanOrEqualTo(200)
        }
    }
    
    func configure(with text: String) {
        memoTextView.text = text
        memoTextView.sizeToFit()
   }

    func setUpData(data: WishListModel) {
        if let memo = data.item_memo {
            memoTextView.text = memo
        }
    }
    
}
