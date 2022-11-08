//
//  NetworkCheck.swift
//  Wishboard
//
//  Created by gomin on 2022/09/29.
//

import Foundation
import Network
import UIKit

final class NetworkCheck {
    static let shared = NetworkCheck()
    public let queue = DispatchQueue.global()
    public let monitor: NWPathMonitor
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown

    // 연결타입
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }

    // monotior 초기화
    public init() {
        monitor = NWPathMonitor()
    }

    // Network Monitoring 시작
    public func startMonitoring(vc: UIViewController) {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in

            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)

            if self?.isConnected == true {
                print("연결됨!")
            } else {
                print("연결안됨!")
                DispatchQueue.main.async {
                    SnackBar(vc, message: .networkCheck)
                }
                
            }
        }
    }

    // Network Monitoring 종료
    public func stopMonitoring() {
        monitor.cancel()
    }

    // Network 연결 타입
    public func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            print("wifi")
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            print("cellular")
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
