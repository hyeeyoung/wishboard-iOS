//
//  ModifyProfileDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/27.
//

import Foundation
import Alamofire

class ModifyProfileDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    let header = APIManager().getHeader()
    
    // MARK: - 사용자 프로필 변경
    func modifyProfileDataManager(_ parameter: ModifyProfileInput, _ viewcontroller: ModifyProfileViewController) {
        AF.request(BaseURL + "/user",
                           method: .put,
                           parameters: parameter,
                           encoder: JSONParameterEncoder.default,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.modifyProfileAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
    // 닉네임만 수정
    func modifyProfileDataManager(_ parameter: ModifyProfileInputNickname, _ viewcontroller: ModifyProfileViewController) {
        AF.request(BaseURL + "/user",
                           method: .put,
                           parameters: parameter,
                           encoder: JSONParameterEncoder.default,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.modifyProfileAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
    // 프로필 이미지만 수정
    func modifyProfileDataManager(_ parameter: ModifyProfileInputProfileImg, _ viewcontroller: ModifyProfileViewController) {
        AF.request(BaseURL + "/user",
                           method: .put,
                           parameters: parameter,
                           encoder: JSONParameterEncoder.default,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.modifyProfileAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
}
