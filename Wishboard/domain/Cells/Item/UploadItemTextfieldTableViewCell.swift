//
//  UploadItemTextfieldTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/10/21.
//

import UIKit

class UploadItemTextfieldTableViewCell: UITableViewCell {

    var textfield = UITextField().then{
        $0.backgroundColor = .clear
        $0.font = TypoStyle.SuitB3.font
        $0.addLeftPadding(16)
        $0.textColor = .gray_700
    }
    
    //MARK: - Life Cycles
    var numberFormatter: NumberFormatter!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTextfieldCell(dataSourceDelegate: UITextFieldDelegate) {
        textfield.delegate = dataSourceDelegate
        self.contentView.addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
    }
    func setPlaceholder(tag: Int) {
        switch tag {
        case 0:
            textfield.placeholder = Placeholder.uploadItemName
        case 1:
            textfield.placeholder = Placeholder.uploadItemPrice
        case 5:
            textfield.placeholder = Placeholder.uploadItemMemo
        default:
            fatalError()
        }
    }
    func setUpData(tag: Int, data: WishListModel) {
        switch tag {
        case 0:
            if let itemName = data.item_name {textfield.text = itemName}
        case 1:
            textfield.keyboardType = .numberPad
            if let price = data.item_price.nilIfEmpty {
                textfield.text = numberFormatter.string(from: NSNumber(value: Int(price)!))
            } else {
                textfield.text = "0"
            }
        default:
            if let memo = data.item_memo {textfield.text = memo}
        }
    }
}
