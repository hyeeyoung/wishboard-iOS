//
//  WishListDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/27.
//

import Foundation
import Alamofire

class WishListDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    let header = APIManager().getHeader()
    
    // MARK: - 홈화면 위시리스트 조회 + 상세 조회
    func wishListDataManager(_ viewcontroller: HomeView) {
        AF.request(BaseURL + "/item",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: [WishListModel].self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.wishListAPISuccess(result)
            case .failure(let error):
                print(error.responseCode)
                print(error.localizedDescription)
            }
        }
    }
}
