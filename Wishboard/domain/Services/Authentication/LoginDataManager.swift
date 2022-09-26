//
//  LoginDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/26.
//

import Alamofire
import SnackBar_swift

class LoginDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    //MARK: 회원가입
    func loginDataManager(_ parameter: LoginInput, _ viewcontroller: LoginViewController) {
        AF.request(BaseURL + "/auth/signin",
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: nil)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                if result.success! {viewcontroller.loginAPISuccess(result)}
            case .failure(let error):
                if let statusCode = error.responseCode {
                    switch statusCode {
                    case 400, 204:
                        viewcontroller.loginAPIFail()
                    default:
                        print(statusCode)
                    }
                }
            }
        }
    }
}
