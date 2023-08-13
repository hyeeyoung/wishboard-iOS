//
//  NotificationDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/29.
//

import Foundation
import Alamofire

class NotificationDataManager {
    // MARK: - 알림 조회
    func getNotificationListDataManager(_ notiView: NotiView) {
        let url = Storage().BaseURL + "/noti"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .get, nil)
        
        AlamofireBaseService.shared.responseDecoded(request, [NotificationModel].self) { result in
            notiView.getNotificationListAPISuccess(result)
        }
    }
    // MARK: - 알림 읽음 처리
    func readNotificationListDataManager(_ itemId: Int, _ notiView: NotiView) {
        let url = Storage().BaseURL + "/noti/\(itemId)/read-state"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .put, nil)
        
        AlamofireBaseService.shared.responseDecoded(request, APIModel<TokenResultModel>.self) { result in
            notiView.readNotificationAPISuccess(result)
        }
    }
    // MARK: - 캘린더 알림 조회
    func getCalenderNotificationDataManager(_ viewcontroller: CalenderViewController) {
        let url = Storage().BaseURL + "/noti/calendar"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .get, viewcontroller)
        
        AlamofireBaseService.shared.responseDecoded(request, [NotificationModel].self) { result in
            viewcontroller.getCalenderNotificationAPISuccess(result)
        }
    }
}
