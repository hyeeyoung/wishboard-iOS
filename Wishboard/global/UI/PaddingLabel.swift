//
//  PaddingLabel.swift
//  Wishboard
//
//  Created by gomin on 2022/09/14.
//

import Foundation
import UIKit

//class PaddingLabel: UILabel {
//    @IBInspectable var topInset: CGFloat = 4.0
//    @IBInspectable var bottomInset: CGFloat = 4.0
//    @IBInspectable var leftInset: CGFloat = 8.0
//    @IBInspectable var rightInset: CGFloat = 8.0
//
//    override func drawText(in rect: CGRect) {
//        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//        super.drawText(in: rect.inset(by: insets))
//    }
//    override var intrinsicContentSize: CGSize {
//        let size = super.intrinsicContentSize
//        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
//    }
//    override var bounds: CGRect {
//        didSet { preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset) }
//    }
//}

class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
