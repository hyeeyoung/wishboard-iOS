//
//  Vibrate.swift
//  Wishboard
//
//  Created by gomin on 2022/11/07.
//

import Foundation
import UIKit
import AVFoundation

extension UIDevice {
    static func vibrate() {
       AudioServicesPlaySystemSound(1519)  // 짧은 진동
   }
}
