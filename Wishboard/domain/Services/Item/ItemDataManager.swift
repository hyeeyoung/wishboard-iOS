//
//  ItemDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/29.
//

import Foundation
import Alamofire

class ItemDataManager {
    let multiHeader = APIManager().getMultipartHeader()
    
    // MARK: - 아이템 상세 조회
    func getItemDetailDataManager(_ itemId: Int,_ viewcontroller: ItemDetailViewController) {
        let url = Storage().BaseURL + "/item/\(itemId)"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .get, viewcontroller)
        
        AlamofireBaseService.shared.responseDecoded(request, [WishListModel].self) { result in
            if !result.isEmpty {
                viewcontroller.getItemDetailAPISuccess(result[0])
            }
        }
    }
    
    // MARK: - 아이템 삭제
    func deleteItemDataManager(_ itemId: Int,_ viewcontroller: ItemDetailViewController) {
        let url = Storage().BaseURL + "/item/\(itemId)"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .delete, viewcontroller)
        
        AlamofireBaseService.shared.responseDecoded(request, APIModel<TokenResultModel>.self) { result in
            viewcontroller.deleteItemAPISuccess()
        }
    }
    // MARK: - 링크 복사로 불러오기
    func getItemByLinkDataManager(_ url: String, _ viewcontroller: ShoppingLinkViewController) {
        let url = Storage().BaseURL + "/item/parse?site=\(url)"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .get, viewcontroller)
        
        AlamofireBaseService.shared.responseDecoded(request, APIModel<ItemParsingModel>.self) { result in
            viewcontroller.getItemByLinkAPISuccess(result)
        }
    }
}
