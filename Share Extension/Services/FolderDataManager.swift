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
        // TODO: TokenInterceptor 적용
        let BaseURL = defaults?.string(forKey: "url") ?? ""
        let token = defaults?.string(forKey: "accessToken") ?? ""
        // 로그아웃 상태일 때
        if token == "" {
            viewcontroller.needLogin()
            return
        }
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Content-type": "application/json",
            "User-Agent": "wishboard-ios/dev"
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
                print("FOLDER 가져오기 error",statusCode)
                switch statusCode {
                case 429:
                    viewcontroller.getFolderListAPIFail()
                case 401:
                    RefreshDataManager().shareExtensionRefreshDataManager {
                        $0 ? FolderDataManager().getFolderListDataManager(viewcontroller) : viewcontroller.uploadItem500Error()
                    }
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
            "Content-type": "application/json",
            "User-Agent": "wishboard-ios/dev"
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
