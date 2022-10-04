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
                case 404:
                    cartView.noCartItem()
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
    // MARK: - 장바구니 추가
    func addCartDataManager(_ parameter: AddCartInput,_ homeView: HomeView, _ viewcontroller: HomeViewController) {
        AF.request(BaseURL + "/cart",
                           method: .post,
                           parameters: parameter,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.addCartAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
    // MARK: - 장바구니 삭제 : 장바구니 페이지
    func deleteCartDataManager(_ itemId: Int, _ cartView: CartView) {
        AF.request(BaseURL + "/cart/\(itemId)",
                           method: .delete,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                cartView.deleteCartAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
    // MARK: - 장바구니 삭제 : 홈 페이지
    func deleteCartDataManager(_ itemId: Int, _ homeView: HomeView, _ viewcontroller: HomeViewController) {
        AF.request(BaseURL + "/cart/\(itemId)",
                           method: .delete,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.deleteCartAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
            }
        }
    }
}
