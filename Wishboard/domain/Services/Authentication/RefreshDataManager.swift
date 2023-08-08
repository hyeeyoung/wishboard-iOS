//
//  RefreshDataManager.swift
//  Wishboard
//
//  Created by gomin on 2023/03/03.
//

import Foundation
import Alamofire

class RefreshDataManager {
    var parameter: RefreshInput!
    
    /* 2가지 경우의 수
     1. 앱 타겟에서 토큰 refresh 로직 실행 (line 22)
     2. 만약 Share Extension에서 해당 로직 실행하면 refreshToken이 nil (line 24)
     -> 그럴 땐 Share Extension UserDefaults에 저장된 refreshToken 가져다가 실행 (line 25-27)
     */
    
    //MARK: Refresh
    func refreshDataManager(completion: @escaping (Bool) -> Void) {
        if let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") {
            parameter = RefreshInput(refreshToken: refreshToken)
        } else {
            let defaults = UserDefaults(suiteName: "group.gomin.Wishboard.Share")
            let refreshToken = defaults?.string(forKey: "refreshToken") ?? ""
            parameter = RefreshInput(refreshToken: refreshToken)
        }
        
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
                
                let defaults = UserDefaults(suiteName: "group.gomin.Wishboard.Share")
                defaults?.set(accessToken, forKey: "accessToken")
                defaults?.set(refreshToken, forKey: "refreshToken")
                defaults?.synchronize()
                
                print("refresh success!", accessToken, refreshToken)
                completion(true)
                
                break
            case .failure(let error):
                if let statusCode = error.responseCode {
                    print("refresh token api FAIL:", statusCode)
                    print(error.localizedDescription)
                }
                completion(false)
            }
        }
    }
}
