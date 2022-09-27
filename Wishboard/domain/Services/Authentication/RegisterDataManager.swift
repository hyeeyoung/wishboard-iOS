//
//  RegisterDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/26.
//

import Foundation
import Alamofire

class RegisterDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    //MARK: 회원가입
    func registerDataManager(_ parameter: RegisterInput, _ viewcontroller: RegisterPasswordViewController) {
        AF.request(BaseURL + "/auth/signup",
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
}
