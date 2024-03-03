//
//  CartDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/28.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

class CartDataManager {
    // MARK: - 장바구니 조회
    func getCartListDataManager(_ cartView: CartView) {
        let url = Storage().BaseURL + "/cart"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .get, nil)
        
        AlamofireBaseService.shared.responseWithErrorException(request, [CartListModel].self) { result in
            if let response = result as? [CartListModel] {
                cartView.getCartListAPISuccess(response)
            } else if let errorCode = result as? Int, errorCode == 404 {
                cartView.noCartItem()
            }
        }
        
    }
    // MARK: - 장바구니 수량 변경
    func modifyCountDataManager(_ itemId: Int, _ parameter: CartModifyCountInput,_ cartView: CartView) {
        let url = Storage().BaseURL + "/cart/\(itemId)"
        let request = AlamofireBaseService.shared.requestWithBody(url, .put, parameter, nil)
        AlamofireBaseService.shared.responseDecoded(request, APIModel<TokenResultModel>.self) { result in
            cartView.modifyCountAPISuccess(result)
        }
    }
    // MARK: - 장바구니 추가
    // 홈 페이지와 폴더 디테일 페이지 구분
    func addCartDataManager(_ parameter: AddCartInput, _ viewcontroller: UIViewController) {
        let url = Storage().BaseURL + "/cart"
        let request = AlamofireBaseService.shared.requestWithBody(url, .post, parameter, viewcontroller)
        AlamofireBaseService.shared.responseDecoded(request, APIModel<TokenResultModel>.self) { result in
            if let viewcontroller = viewcontroller as? HomeViewController {
                viewcontroller.addCartAPISuccess(result)
            } else if let viewcontroller = viewcontroller as? FolderDetailViewController {
                viewcontroller.addCartAPISuccess(result)
            } else {return}
        }
    }

    // MARK: - 장바구니 삭제
    /// 분기처리 : 장바구니 페이지 / 홈 페이지 / 폴더 디테일 페이지
    func deleteCartDataManager(_ itemId: Int, _ viewcontroller: Any) {
        let url = Storage().BaseURL + "/cart/\(itemId)"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .delete, nil)
        
        AlamofireBaseService.shared.responseDecoded(request, APIModel<TokenResultModel>.self) { result in
            if let cartView = viewcontroller as? CartView {
                cartView.deleteCartAPISuccess(result)
            } else if let viewcontroller = viewcontroller as? HomeViewController {
                viewcontroller.deleteCartAPISuccess(result)
            } else if let viewcontroller = viewcontroller as? FolderDetailViewController {
                viewcontroller.deleteCartAPISuccess(result)
            } else {return}
        }
        
    }
    
}
