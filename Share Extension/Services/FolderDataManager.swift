//
//  FolderDataManager.swift
//  Share Extension
//
//  Created by gomin on 2022/09/29.
//

import Foundation
import Alamofire

class FolderDataManager {
    let defaults = UserDefaults(suiteName: "group.gomin.Wishboard.Share")
    
    // MARK: - 폴더 리스트 조회
    func getFolderListDataManager(_ viewcontroller: ShareViewController) {
        let BaseURL = defaults?.string(forKey: "url") ?? ""
        let token = defaults?.string(forKey: "accessToken") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        AF.request(BaseURL + "/folder/list",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: [FolderListModel].self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.getFolderListAPISuccess(result)
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
    // MARK: - 폴더 추가
    func addFolderDataManager(_ parameter: AddFolderInput, _ viewcontroller: NewFolderViewController) {
        let BaseURL = defaults?.string(forKey: "url") ?? ""
        let token = defaults?.string(forKey: "accessToken") ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        AF.request(BaseURL + "/folder",
                           method: .post,
                           parameters: parameter,
                           encoder: JSONParameterEncoder.default,
                           headers: header)
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.addFolderAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 409:
                    viewcontroller.sameFolderNameFail()
                case 429:
                    viewcontroller.addFolderAPIFail()
                default:
                    print(error.localizedDescription)
                    print(error.responseCode)
                }
            }
        }
    }
}
