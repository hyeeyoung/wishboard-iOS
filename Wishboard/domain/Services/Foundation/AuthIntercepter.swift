//
//  AuthIntercepter.swift
//  Wishboard
//
//  Created by gomin on 2023/08/13.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    static let shared = AuthInterceptor()
    private var isRefreshingToken = false
    
    var viewcontroller: UIViewController?
    
    private init() {
        
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
       
        let accessToken = UserManager.accessToken ?? ""
        
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        print("adaptor 적용 \(urlRequest.headers)")
        completion(.success(urlRequest))
        
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse else {return}
        
        // 이미 토큰을 갱신 중이라면 재시도를 막음
        guard !isRefreshingToken else {
            completion(.doNotRetry)
            return
        }
        
        switch response.statusCode {
        case 401:
            isRefreshingToken = true
            // 토큰 갱신 API 호출
            RefreshDataManager().refreshDataManager { didRefreshToken in
                
                DispatchQueue.main.async {
                    if didRefreshToken {
                        print("Renew Token success At AuthInterceptor")
                        completion(.retry)
                    } else {
                        #if WISHBOARD_APP
                        ScreenManager.shared.goToOnboarding()
                        
                        #elseif SHARE_EXTENSION
                        DispatchQueue.main.async {
                            if let vc = self.viewcontroller {
                                ErrorBar(vc)
                            }
                        }
                        
                        #endif
                        completion(.doNotRetryWithError(error))
                    }
                    
                    self.isRefreshingToken = false
                }
            }
            return
        case 500:
            // 서버 500에러
            print("server 500 error")
            DispatchQueue.main.async {
                if let vc = self.viewcontroller {
                    ErrorBar(vc)
                }
            }
            completion(.doNotRetryWithError(error))
            return
        default:
            print(error.localizedDescription)
            completion(.doNotRetryWithError(error))
            return
        }
    }
}
