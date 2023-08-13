//
//  BaseService.swift
//  Wishboard
//
//  Created by gomin on 2023/08/13.
//

import Foundation
import Alamofire

class AlamofireBaseService {
    static let shared = AlamofireBaseService()
    
    private init() {}
    
    /// 서버 요청값
    func requestWithParameter(_ url: String, _ method: HTTPMethod, _ viewcontroller: UIViewController?) -> DataRequest {
        let request = AF.request(url,
                   method: method,
                   parameters: nil,
                   headers: APIManager().getHeader(),
                   interceptor: AuthInterceptor(viewcontroller))
        .validate()
        
        return request
    }
    
    func requestWithBody(_ url: String, _ method: HTTPMethod, _ model: Encodable, _ viewcontroller: UIViewController?) -> DataRequest {
        let request = AF.request(url,
                   method: method,
                   parameters: model,
                   encoder: JSONParameterEncoder.default,
                   headers: APIManager().getHeader(),
                   interceptor: AuthInterceptor(viewcontroller))
        .validate()
        
        return request
    }
    
    /// 서버 응답값
    func responseDecoded<T: Decodable>(_ request: DataRequest, _ model: T.Type, completion: @escaping ((T) -> Void)) {
        request.responseDecodable(of: T.self) { response in
            print(response)
            switch response.result {
            case .success(let result):
                completion(result)
            case .failure(let error):
//                completion(false)
                print(error.responseCode)
            }
        }
    }
    
    func responseWithBasicModel(_ request: DataRequest, completion: @escaping ((Bool) -> Void)) {
        request.responseDecodable(of: APIModel<Bool>.self) { response in
            switch response.result {
            case .success(let result):
                completion(true)
            case .failure(let error):
                completion(false)
                print(error.responseCode)
            }
        }
    }
    
    func responseWithString(_ request: DataRequest, completion: @escaping ((Any) -> Void)) {
        request.responseString { response in
            print("String:\(response.result)")
             switch(response.result) {
             case .success(_):
                 print("success")
//                 if let data = response.result.value {
//                   print(data)
//                  }
          
             case .failure(_):
                 print("Error message:\(response.result)")
                 break
              }
          }
    }
    
}
