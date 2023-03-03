//
//  RefreshDataManager.swift
//  Wishboard
//
//  Created by gomin on 2023/03/03.
//

import Foundation
import Alamofire

class RefreshDataManager {
    //MARK: Refresh
    func refreshDataManager(_ parameter: RefreshInput) {
        AF.request(Storage().BaseURL + "/auth/refresh",
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: nil)
            .validate()
            .responseDecodable(of: APIModel<TokenResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                let accessToken = result.data?.token.accessToken
                let refreshToken = result.data?.token.refreshToken
                
                UserDefaults.standard.set(accessToken, forKey: "accessToken")
                UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
//                if result.success! {viewcontroller.refreshAPISuccess(result); print(result)}
            case .failure(let error):
                if let statusCode = error.responseCode {
                    print("token refresh fail:", statusCode)
                }
            }
        }
    }
}
