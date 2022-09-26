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
    
    // MARK: - 사용자 정보 조회
    func getUserInfoDataManager(_ viewcontroller: MyPageViewController) {
        let header = APIManager().getHeader()
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
                print(error.responseCode)
            }
        }
    }
}
