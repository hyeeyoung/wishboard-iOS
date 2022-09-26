//
//  CheckEmailDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/27.
//

import Alamofire

class CheckEmailDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    
    //MARK: 이메일 인증 - 회원가입 시
    func checkEmailDataManager(_ parameter: CheckEmailInput, _ viewcontroller: RegisterEmailViewController) {
        AF.request(BaseURL + "/auth/check-email",
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
