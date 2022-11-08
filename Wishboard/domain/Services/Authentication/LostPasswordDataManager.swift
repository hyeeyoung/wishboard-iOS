//
//  LostPasswordDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/28.
//

import Foundation
import Alamofire

class LostPasswordDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    let header = APIManager().getHeader()
    
    //MARK: 이메일 인증 - 회원가입 시
    func checkEmailDataManager(_ parameter: CheckEmailInput, _ viewcontroller: LostPasswordViewController) {
        AF.request(BaseURL + "/auth/password-mail",
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: header)
            .validate()
            .responseDecodable(of: APIModel<LostPasswordModel>.self) { response in
            switch response.result {
            case .success(let result):
                if result.success! {viewcontroller.checkEmailAPISuccess(result)}
            case .failure(let error):
                if let statusCode = error.responseCode {
                    switch statusCode {
                    case 404:   //존재하지 않는 유저
                        viewcontroller.checkEmaiAPIFail()
                    default:
                        print(statusCode)
                    }
                }
            }
        }
    }
    //MARK: 이메일 인증 - 회원가입 시
    func verifyCodeDataManager(_ parameter: LostPasswordInput, _ viewcontroller: GetEmailViewController) {
        AF.request(BaseURL + "/auth/re-signin",
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: header)
            .validate()
            .responseDecodable(of: APIModel<VerifyCodeModel>.self) { response in
            switch response.result {
            case .success(let result):
                if result.success! {viewcontroller.verifyCodeAPISuccess(result)}
            case .failure(let error):
                if let statusCode = error.responseCode {
                    switch statusCode {
                    case 404:   //존재하지 않는 유저
                        print("유효하지 않은 인증번호")
                    default:
                        print(statusCode)
                    }
                }
            }
        }
    }
}
