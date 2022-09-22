//
//  ScreenManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/23.
//

import Foundation
import UIKit

class ScreenManager {
    func goMainPages(_ index: Int, _ viewcontroller: UIViewController) {
        guard let tabBarController = viewcontroller.tabBarController else {return}
        tabBarController.selectedIndex = index
        tabBarController.viewDidLoad()
        tabBarController.modalPresentationStyle = .fullScreen
        viewcontroller.view.window?.windowScene?.keyWindow?.rootViewController = tabBarController
    }
}
