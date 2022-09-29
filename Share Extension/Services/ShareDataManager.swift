//
//  ShareDataManager.swift
//  Share Extension
//
//  Created by gomin on 2022/09/29.
//

import Foundation
import Alamofire

class ShareDataManager {
    let defaults = UserDefaults(suiteName: "group.gomin.Wishboard.Share")
    
    // MARK: - 아이템 정보 파싱
    func getItemDataDataManager(_ url: String, _ viewcontroller: ShareViewController) {
        print("start get item parsing")
        let BaseURL = defaults?.string(forKey: "url") ?? ""
        let token = defaults?.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        AF.request(BaseURL + "/item/parse?site=\(url)",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ItemParsingModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.getItemDataAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 429:
                    viewcontroller.getFolderListAPIFail()
                default:
                    print(error.localizedDescription)
                    print(error.responseCode)
                }
            }
        }
    }
}
