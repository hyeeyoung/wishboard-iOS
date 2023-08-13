//
//  AuthIntercepter.swift
//  Wishboard
//
//  Created by gomin on 2023/08/13.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {

    var viewcontroller: UIViewController?
    
    init(_ viewcontroller: UIViewController?) {
        self.viewcontroller = viewcontroller
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
       
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
        
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        print("adaptor 적용 \(urlRequest.headers)")
        completion(.success(urlRequest))
        
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse else {return}
        
        switch response.statusCode {
        case 401:
            // 토큰 갱신 API 호출
            RefreshDataManager().refreshDataManager { result in
                print("Renew Token success")
            }
        case 500:
            // 서버 500에러
            print("server 500 error")
            DispatchQueue.main.async {
                if let vc = self.viewcontroller {
                    ErrorBar(vc)
                }
            }
            return
        default:
            print(error.localizedDescription)
            completion(.doNotRetryWithError(error))
            return
        }
    }
}
