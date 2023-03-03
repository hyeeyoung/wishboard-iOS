//
//  FCMDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/30.
//

import Foundation
import Alamofire

class FCMDataManager {
    let header = APIManager().getHeader()
    
    // MARK: - FCM
    // 회원가입 이후
    func fcmDataManager(_ parameter: FCMInput, _ viewcontroller: RegisterPasswordViewController) {
        AF.request(Storage().BaseURL + "/user/fcm",
                           method: .put,
                           parameters: parameter,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<TokenResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.fcmAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    DispatchQueue.main.async {
                        viewcontroller.sendFCM()
                    }
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager(RefreshInput(accessToken: UserDefaults.standard.string(forKey: "accessToken") ?? "", refreshToken: UserDefaults.standard.string(forKey: "refreshToken") ?? ""))
                default:
                    print(error.localizedDescription)
                }
                print(error.responseCode)
            }
        }
    }
    // 로그인 이후
    func fcmDataManager(_ parameter: FCMInput, _ viewcontroller: LoginViewController) {
        AF.request(Storage().BaseURL + "/user/fcm",
                           method: .put,
                           parameters: parameter,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<TokenResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.fcmAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    DispatchQueue.main.async {
                        viewcontroller.sendFCM()
                    }
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager(RefreshInput(accessToken: UserDefaults.standard.string(forKey: "accessToken") ?? "", refreshToken: UserDefaults.standard.string(forKey: "refreshToken") ?? ""))
                default:
                    print(error.localizedDescription)
                }
                print(error.responseCode)
            }
        }
    }
    // 자동 로그인 이후
    func fcmDataManager(_ parameter: FCMInput, _ viewcontroller: OnBoardingViewController) {
        AF.request(Storage().BaseURL + "/user/fcm",
                           method: .put,
                           parameters: parameter,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<TokenResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.fcmAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    DispatchQueue.main.async {
                        viewcontroller.sendFCM()
                    }
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager(RefreshInput(accessToken: UserDefaults.standard.string(forKey: "accessToken") ?? "", refreshToken: UserDefaults.standard.string(forKey: "refreshToken") ?? ""))
                default:
                    print(error.localizedDescription)
                }
                print(error.responseCode)
            }
        }
    }
}
