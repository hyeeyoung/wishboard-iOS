//
//  WishListDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/27.
//

import Foundation
import Alamofire

class WishListDataManager {
    let header = APIManager().getHeader()
    
    // MARK: - 홈화면 위시리스트 조회
    func wishListDataManager(_ homeView: HomeView, _ viewcontroller: HomeViewController) {
        print("위시리스트 조회 호출")
        AF.request(Storage().BaseURL + "/item",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: [WishListModel].self) { response in
            switch response.result {
            case .success(let result):
                homeView.wishListAPISuccess(result)
                print("위시리스트 success")
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
//                case 429:
//                    viewcontroller.wishListAPIFail()
//                    print("위시리스트 429")
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                        print("위시리스트 500")
                    }
                case 401:
                    print("status code: 401")
                    print("refresh api 요청")
                    RefreshDataManager().refreshDataManager() {
                        self.wishListDataManager(homeView, viewcontroller)
                    }
                    defer {
                        self.wishListDataManager(homeView, viewcontroller)
                    }
                default:
                    print("위시리스트 default")
                    print(error.responseCode)
                }
                print("wishlist:", error.responseCode)
            }
        }
    }
}
