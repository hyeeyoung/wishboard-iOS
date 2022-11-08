//
//  MypageDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/27.
//

import Foundation
import Alamofire

class MypageDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    let header = APIManager().getHeader()
    
    // MARK: - 사용자 정보 조회
    func getUserInfoDataManager(_ viewcontroller: MyPageViewController) {
        AF.request(BaseURL + "/user",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: [GetUserInfoModel].self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.getUserInfoAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    viewcontroller.getUserInfoAPIFail()
                default:
                    print(error.responseCode)
                }
            }
        }
    }
    // MARK: - 알림 토글 수정
    // 마이페이지
    func switchNotificationDataManager(_ isOn: Bool, _ viewcontroller: MyPageViewController) {
        AF.request(BaseURL + "/user/push-state/\(isOn)",
                           method: .put,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.switchNotificationAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
    // 앱 이용방법 후 (회원가입 후)
    func switchNotificationDataManager(_ isOn: Bool, _ viewcontroller: HomeViewController) {
        AF.request(BaseURL + "/user/push-state/\(isOn)",
                           method: .put,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.switchNotificationAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
    // MARK: - 회원 탈퇴
    func deleteUserDataManager(_ viewcontroller: MyPageViewController) {
        AF.request(BaseURL + "/user",
                           method: .delete,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.deleteUserAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
    // MARK: - 로그아웃
    func logoutDataManager(_ viewcontroller: MyPageViewController) {
        let logoutInput = FCMInput(fcm_token: nil)
        AF.request(BaseURL + "/user/fcm",
                           method: .put,
                           parameters: logoutInput,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.logoutAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
}
