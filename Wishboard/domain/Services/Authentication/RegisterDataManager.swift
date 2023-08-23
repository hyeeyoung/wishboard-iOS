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
        
        let url = Storage().BaseURL + "/auth/signup"
        let request = AlamofireBaseService.shared.requestWithBody(url, .post, parameter, viewcontroller)
        
        AlamofireBaseService.shared.responseWithErrorException(request, APIModel<TokenResultModel>.self) { result in
            if let response = result as? APIModel<TokenResultModel>, response.success {
                viewcontroller.registerAPISuccess(response)
            }
        }
        
    }
    //MARK: 이메일 인증 - 회원가입 시
    func checkEmailDataManager(_ parameter: CheckEmailInput, _ viewcontroller: RegisterEmailViewController) {
        let url = Storage().BaseURL + "/auth/check-email"
        let request = AlamofireBaseService.shared.requestWithBody(url, .post, parameter, viewcontroller)
        
        AlamofireBaseService.shared.responseWithErrorException(request, APIModel<TokenResultModel>.self) { result in
            if let response = result as? APIModel<TokenResultModel>, response.success {
                viewcontroller.checkEmailAPISuccess(response)
            } else if let errorCode = result as? Int, errorCode == 409 {
                viewcontroller.checkEmaiAPIFail()
            }
        }
        
    }
}
