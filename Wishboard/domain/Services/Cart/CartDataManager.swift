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
    
    // MARK: - 장바구니 조회
    func getCartListDataManager(_ cartView: CartView) {
        AF.request(BaseURL + "/cart",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: [CartListModel].self) { response in
            switch response.result {
            case .success(let result):
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
    // MARK: - 장바구니 수량 변경
    func modifyCountDataManager(_ itemId: Int, _ parameter: CartModifyCountInput,_ cartView: CartView) {
        AF.request(BaseURL + "/cart/\(itemId)",
                           method: .put,
                           parameters: parameter,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                cartView.modifyCountAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
}
