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
    
    //MARK: Refresh
    /// 앱 에서 refresh 호출 - tokenInterceptor
    func refreshDataManager(completion: @escaping (Bool) -> Void) {
        if let refreshToken = UserManager.refreshToken {
            parameter = RefreshInput(refreshToken: refreshToken)
            print("Refresh Manager 호출 -> refreshToken: \(refreshToken)")
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
                
                UserManager.accessToken = accessToken
                UserManager.refreshToken = refreshToken
                
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
                break
            }
        }
    }
    /// 링크공유에서 refresh 호출
    func shareExtensionRefreshDataManager(completion: @escaping (Bool) -> Void) {
        let defaults = UserDefaults(suiteName: "group.gomin.Wishboard.Share")
        let refreshToken = defaults?.string(forKey: "refreshToken") ?? ""
        parameter = RefreshInput(refreshToken: refreshToken)
        
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
                
                UserManager.accessToken = accessToken
                UserManager.refreshToken = refreshToken
                
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
