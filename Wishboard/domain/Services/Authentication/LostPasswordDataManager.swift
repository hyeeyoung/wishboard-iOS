//
//  LostPasswordDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/28.
//

import Foundation
import Alamofire

class LostPasswordDataManager {
    let header = APIManager().getHeader()
    
    //MARK: 이메일 전송 - 비밀번호 없이 로그인
    func checkEmailDataManager(_ parameter: CheckEmailInput, _ viewcontroller: LostPasswordViewController) {
        AF.request(Storage().BaseURL + "/auth/password-mail",
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: APIManager().getHeader())
            .validate()
            .responseDecodable(of: APIModel<LostPasswordModel>.self) { response in
            switch response.result {
            case .success(let result):
                if result.success {viewcontroller.checkEmailAPISuccess(result)}
            case .failure(let error):
                if let statusCode = error.responseCode {
                    switch statusCode {
                    case 404:   //존재하지 않는 유저
                        viewcontroller.checkEmaiAPIFail()
                    case 500:
                       DispatchQueue.main.async {
                           ErrorBar(viewcontroller)
                       }
                    default:
                        print(statusCode)
                    }
                }
            }
        }
    }
    //MARK: 이메일 인증번호 확인 - 비밀번호 없이 로그인
    func verifyCodeDataManager(_ parameter: LostPasswordInput, _ viewcontroller: GetEmailViewController) {
        AF.request(Storage().BaseURL + "/auth/re-signin",
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: APIManager().getHeader())
            .validate()
            .responseDecodable(of: APIModel<VerifyCodeModel>.self) { response in
            switch response.result {
            case .success(let result):
                if result.success {viewcontroller.verifyCodeAPISuccess(result)}
            case .failure(let error):
                if let statusCode = error.responseCode {
                    switch statusCode {
                    case 404:   //존재하지 않는 유저
                        print("유효하지 않은 인증번호")
                    case 500:
                       DispatchQueue.main.async {
                           ErrorBar(viewcontroller)
                       }
                    case 401:
                        RefreshDataManager().refreshDataManager() {
                            !$0 ? ScreenManager.shared.goToOnboarding() : self.verifyCodeDataManager(parameter, viewcontroller)
                        }
                    default:
                        print(statusCode)
                    }
                }
            }
        }
    }
}
