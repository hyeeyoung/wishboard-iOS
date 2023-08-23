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
    
    // MARK: - Request
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
    
    // MARK: - Response
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
    
    /// Error Exception이 필요한 reponse
    /// responseCode (응답코드)를 completion으로 전달한다.
    func responseWithErrorException<T: Decodable>(_ request: DataRequest, _ model: T.Type, completion: @escaping ((Any) -> Void)) {
        request.responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let result):
                completion(result)
            case .failure(_):
                guard let response = request.task?.response as? HTTPURLResponse else {return}
                completion(response.statusCode)
            }
        }
    }
    
    func responseWithString(_ request: DataRequest, completion: @escaping ((Any) -> Void)) {
        request.responseString { response in
            print("String:\(response.result)")
             switch(response.result) {
             case .success(_):
                 print("success")
             case .failure(_):
                 print("Error message:\(response.result)")
                 break
              }
          }
    }
    
}
