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
        AF.request(Storage().BaseURL + "/item/\(itemId)",
                   method: .get,
                   parameters: nil,
                   headers: APIManager().getHeader())
        .validate()
        .responseDecodable(of: [WishListModel].self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.getItemDetailAPISuccess(result[0])
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                    //                case 429:
                    //                    viewcontroller.getItemDetailAPIFail()
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager() {
                        !$0 ? ScreenManager().goToOnboarding(viewcontroller) : self.getItemDetailDataManager(itemId, viewcontroller)
                    }
                default:
                    print(error.responseCode)
                }
            }
        }
    }
    
    // MARK: - 아이템 삭제
    func deleteItemDataManager(_ itemId: Int,_ viewcontroller: ItemDetailViewController) {
        AF.request(Storage().BaseURL + "/item/\(itemId)",
                   method: .delete,
                   parameters: nil,
                   headers: APIManager().getHeader())
        .validate()
        .responseDecodable(of: APIModel<TokenResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.deleteItemAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    viewcontroller.deleteItemAPIFail429()
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager() {
                        !$0 ? ScreenManager().goToOnboarding(viewcontroller) : self.deleteItemDataManager(itemId, viewcontroller)
                    }
                default:
                    print(error.responseCode)
                }
            }
        }
    }
    // MARK: - 링크 복사로 불러오기
    func getItemByLinkDataManager(_ url: String, _ viewcontroller: ShoppingLinkViewController) {
        AF.request(Storage().BaseURL + "/item/parse?site=\(url)",
                   method: .get,
                   parameters: nil,
                   headers: APIManager().getHeader())
        .validate()
        .responseDecodable(of: APIModel<ItemParsingModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.getItemByLinkAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 404, 204:
                    viewcontroller.getItemByLinkAPIFail()
                case 429:
                    viewcontroller.getItemByLinkAPIFail429()
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager() {
                        !$0 ? ScreenManager().goToOnboarding(viewcontroller) : self.getItemByLinkDataManager(url, viewcontroller)
                    }
                default:
                    print(error.localizedDescription)
                    print(error.responseCode)
                }
            }
        }
    }
}
