//
//  Bundle.swift
//  Wishboard
//
//  Created by gomin on 2022/12/02.
//

import Foundation

extension Bundle{
    class var displayName : String{
        if let value = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String{
            return value
        }
        return ""
    }

    class var appVersion: String{
        if let value = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return value
        }
        return ""
    }

    class var appBuildVersion: String{
        if let value = Bundle.main.infoDictionary?["CFBundleVersion"] as? String{
            return value
        }
        return ""
    }

    class var bundleIdentifier: String{
        if let value = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
            return value
        }
        return ""
    }
}
