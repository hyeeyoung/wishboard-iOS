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
    func refreshDataManager(completion: @escaping (Bool) -> Void) {
        let parameter = RefreshInput(refreshToken: UserDefaults.standard.string(forKey: "refreshToken") ?? "")
        print("refresh token:", parameter)
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
//        return isRefreshed
//        .responseString { response in
//               print("String:\(response.result.value)")
//               switch(response.result) {
//               case .success(_):
//                  if let data = response.result.value{
//                     print(data)
//                    }
//
//               case .failure(_):
//                   print("Error message:\(response.result.error)")
//                   break
//                }
//            }
