//
//  UIView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/10.
//

import UIKit

extension UIView {
    // View의 모서리마다 다른 radius값 주기
        func roundCornersDiffernt(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
            let topLeftRadius = CGSize(width: topLeft, height: topLeft)
            let topRightRadius = CGSize(width: topRight, height: topRight)
            let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
            let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
            let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            layer.mask = shape
        }
}
