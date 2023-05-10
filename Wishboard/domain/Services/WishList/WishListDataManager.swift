//
//  WishListDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/27.
//

import Foundation
import Alamofire

class WishListDataManager {
    
    // MARK: - 홈화면 위시리스트 조회
    func wishListDataManager(_ homeView: HomeView, _ viewcontroller: HomeViewController) {
        AF.request(Storage().BaseURL + "/item",
                           method: .get,
                           parameters: nil,
                           headers: APIManager().getHeader())
            .validate()
            .responseDecodable(of: [WishListModel].self) { response in
            switch response.result {
            case .success(let result):
                homeView.wishListAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
//                case 429:
//                    viewcontroller.wishListAPIFail()
//                    print("위시리스트 429")
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager() {
                        self.wishListDataManager(homeView, viewcontroller)
                    }
                    
                default:
                    print(error.responseCode)
                }
            }
        }
    }
}
