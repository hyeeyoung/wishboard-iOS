//
//  WishListDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/27.
//

import Foundation
import Alamofire

class WishListDataManager {
    static let shared = WishListDataManager()
    
    private init() { }
    
    // MARK: 홈화면 위시리스트 조회
    func wishListDataManager(_ viewcontroller: HomeViewController) {
        let url = Storage().BaseURL + "/item"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .get, viewcontroller)
        
        AlamofireBaseService.shared.responseWithErrorException(request, [WishListModel].self) { result in
            if let response = result as? [WishListModel] {
                viewcontroller.wishListAPISuccess(response)
            } else if let errorCode = result as? Int {
                switch errorCode {
                case 404:
                    print("홈화면 위시리스트 조회: 404 Error - 위시리스트가 존재하지 않음")
                case 304:
                    print("홈화면 위시리스트 조회: 304 Error")
                default:
                    print("홈화면 위시리스트 조회 Error")
                    
                }
            }
        }
    }
}
