//
//  FCMDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/30.
//

import Foundation
import Alamofire

class FCMDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    let header = APIManager().getHeader()
    
    // MARK: - FCM
    func fcmDataManager(_ parameter: FCMInput, _ viewcontroller: AppDelegate) {
        AF.request(BaseURL + "/user/fcm",
                           method: .put,
                           parameters: parameter,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.fcmAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    viewcontroller.sendFCM()
                default:
                    print(error.localizedDescription)
                }
                print(error.responseCode)
            }
        }
    }
}
