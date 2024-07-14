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
        
        // URL 인코딩
        if let encodedAddress = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let request = AlamofireBaseService.shared.requestWithParameter(encodedAddress, .get, viewcontroller)
            
            AlamofireBaseService.shared.responseWithErrorException(request, APIModel<ItemParsingModel>.self) { result in
                if let response = result as? APIModel<ItemParsingModel> {
                    viewcontroller.getItemByLinkAPISuccess(response)
                } else if let errorCode = result as? Int, errorCode == 404 {
                    // 아이템 정보를 불러오지 못했을 떄: 404
                    viewcontroller.getItemByLinkAPIFail()
                }
            }
        } else {
            print("주소 인코딩 실패")
        }
    }
}
