//
//  VersionDataManager.swift
//  Wishboard
//
//  Created by gomin on 9/25/24.
//

import Foundation
import Alamofire

class VersionDataManager {
    
    // MARK: - 폴더 조회
    func getVersionDataManager(_ viewcontroller: SplashViewController) {
        let header: HTTPHeaders = [
            "Content-type": "application/json",
            "User-Agent": Storage().AgentHeader
        ]
        AF.request(Storage().BaseURL + "/version/check?osType=iOS",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: VersionModel.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.checkAppVersion(result)
            case .failure(let error):
                let statusCode = error.responseCode
                print("VERSION 가져오기 error", error.localizedDescription)
            }
        }
               
    }
}
