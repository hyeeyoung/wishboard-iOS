//
//  LoginDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/26.
//

import Alamofire

class LoginDataManager {
    //MARK: 로그인
    func loginDataManager(_ parameter: LoginInput, _ viewcontroller: LoginViewController) {
        AF.request(Storage().BaseURL + "/auth/signin",
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: nil)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                if result.success! {viewcontroller.loginAPISuccess(result); print(result)}
            case .failure(let error):
                if let statusCode = error.responseCode {
                    switch statusCode {
                    case 400, 204:
                        viewcontroller.loginAPIFail()
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
}
