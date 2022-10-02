//
//  NotificationDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/29.
//

import Foundation
import Alamofire

class NotificationDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    let header = APIManager().getHeader()
    
    // MARK: - 알림 조회
    func getNotificationListDataManager(_ notiView: NotiView) {
        AF.request(BaseURL + "/noti",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: [NotificationModel].self) { response in
            switch response.result {
            case .success(let result):
                notiView.getNotificationListAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    notiView.getNotificationListAPIFail()
                default:
                    print(error.responseCode)
                }
            }
        }
    }
    // MARK: - 알림 읽음 처리
    func readNotificationListDataManager(_ itemId: Int, _ notiView: NotiView) {
        AF.request(BaseURL + "/noti/\(itemId)/read-state",
                           method: .put,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                notiView.readNotificationAPISuccess(result)
            case .failure(let error):
//                let statusCode = error.responseCode
//                switch statusCode {
//                case 429:
//                    notiView.getNotificationListAPIFail()
//                default:
//                    print(error.responseCode)
//                }
                print(error.responseCode)
            }
        }
    }
    // MARK: - 캘린더 알림 조회
    func getCalenderNotificationDataManager(_ tableViewCell: CalenderTableViewCell) {
        AF.request(BaseURL + "/noti/calendar",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: [NotificationModel].self) { response in
            switch response.result {
            case .success(let result):
                tableViewCell.getCalenderNotificationAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    tableViewCell.getCalenderNotificationAPIFail()
                default:
                    print(error.responseCode)
                }
            }
        }
    }
    // MARK: - 캘린더 알림 조회
    func getCalenderNotificationDataManager(_ tableViewCell: CalenderNotiTableViewCell) {
        AF.request(BaseURL + "/noti/calendar",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: [NotificationModel].self) { response in
            switch response.result {
            case .success(let result):
                tableViewCell.getCalenderNotificationAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    tableViewCell.getCalenderNotificationAPIFail()
                    print(error.responseCode)
                default:
                    print(error.responseCode)
                }
            }
        }
    }

}
