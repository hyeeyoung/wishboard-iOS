//
//  FolderDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/28.
//

import Foundation
import Alamofire

class FolderDataManager {
    let BaseURL = UserDefaults.standard.string(forKey: "url") ?? ""
    let header = APIManager().getHeader()
    
    // MARK: - 폴더 조회
    func getFolderDataManager(_ viewcontroller: FolderViewController) {
        AF.request(BaseURL + "/folder",
                           method: .get,
                           parameters: nil,
                           headers: header)
            .validate()
            .responseDecodable(of: [FolderModel].self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.getFolderAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 404:
                    viewcontroller.getFolderAPIFail()
                default:
                    print(error.responseCode)
                }
            }
        }
    }
}
