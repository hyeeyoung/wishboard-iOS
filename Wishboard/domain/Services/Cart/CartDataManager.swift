//
//  CartDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/28.
//

import Foundation
import Alamofire

class CartDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    let header = APIManager().getHeader()
    
    // MARK: - 폴더 조회
    func getFolderDataManager(_ cartView: CartView) {
        AF.request(BaseURL + "/cart",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: [CartListModel].self) { response in
            switch response.result {
            case .success(let result):
                print("cart::",result)
                cartView.getCartListAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    cartView.getCartListAPIFail()
                default:
                    print(error.responseCode)
                }
            }
        }
    }
}
