//
//  RegisterDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/26.
//

import Foundation
import Alamofire

class RegisterDataManager {
    //MARK: 회원가입
    func registerDataManager(_ parameter: RegisterInput, _ viewcontroller: RegisterPasswordViewController) {
        AF.request(Storage().BaseURL + "/auth/signup",
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: nil)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                if result.success! {viewcontroller.registerAPISuccess(result)}
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //MARK: 이메일 인증 - 회원가입 시
    func checkEmailDataManager(_ parameter: CheckEmailInput, _ viewcontroller: RegisterEmailViewController) {
        AF.request(Storage().BaseURL + "/auth/check-email",
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: nil)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                if result.success! {viewcontroller.checkEmailAPISuccess(result)}
            case .failure(let error):
                if let statusCode = error.responseCode {
                    switch statusCode {
                    case 409:
                        viewcontroller.checkEmaiAPIFail()
                    default:
                        print(statusCode)
                    }
                }
            }
        }
    }
}
