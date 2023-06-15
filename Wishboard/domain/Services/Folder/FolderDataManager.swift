//
//  FolderDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/28.
//

import Foundation
import Alamofire

class FolderDataManager {
    
    // MARK: - 폴더 조회
    func getFolderDataManager(_ viewcontroller: FolderViewController) {
//        print("폴더 조회 호출")
        AF.request(Storage().BaseURL + "/folder",
                           method: .get,
                           parameters: nil,
                           headers: APIManager().getHeader())
            .validate()
            .responseDecodable(of: [FolderModel].self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.getFolderAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
//                case 429:
//                    viewcontroller.getFolderAPIFail()
                case 404:
                    viewcontroller.noFolder()
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager() {
                        $0 ? self.getFolderDataManager(viewcontroller) : ScreenManager().goToOnboarding(viewcontroller)
                        return
                    }
                default:
                    print(error.responseCode)
                }
            }
        }
    }
    // MARK: - 폴더 추가
    func addFolderDataManager(_ parameter: AddFolderInput, _ viewcontroller: NewFolderBottomSheetViewController, _ preVC: FolderViewController) {
        AF.request(Storage().BaseURL + "/folder",
                           method: .post,
                           parameters: parameter,
                           encoder: JSONParameterEncoder.default,
                           headers: APIManager().getHeader())
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                preVC.addFolderAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 409:
                    viewcontroller.sameFolderNameFail()
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager() {
                        !$0 ? ScreenManager().goToOnboarding(viewcontroller) : self.addFolderDataManager(parameter, viewcontroller, preVC)
                    }
                default:
                    print(error.responseCode)
                }
                print(error.responseCode)
            }
        }
    }
    // MARK: - 폴더명 수정
    func modifyFolderDataManager(_ folderId: Int, _ parameter: AddFolderInput, _ viewcontroller: ModifyFolderBottomSheetViewController, _ preVC: FolderViewController) {
        AF.request(Storage().BaseURL + "/folder/\(folderId)",
                           method: .put,
                           parameters: parameter,
                           encoder: JSONParameterEncoder.default,
                           headers: APIManager().getHeader())
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                preVC.modifyFolderAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 400, 409:
                    viewcontroller.sameFolderNameFail()
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager() {
                        !$0 ? ScreenManager().goToOnboarding(viewcontroller) : self.modifyFolderDataManager(folderId, parameter, viewcontroller, preVC)
                    }
                default:
                    print(error.responseCode)
                }
                print(error.responseCode)
            }
        }
    }
    // MARK: - 폴더 삭제
    func deleteFolderDataManager(_ folderId: Int, _ viewcontroller: FolderViewController) {
        AF.request(Storage().BaseURL + "/folder/\(folderId)",
                           method: .delete,
                           parameters: nil,
                           headers: APIManager().getHeader())
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.deleteFolderAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager() {
                        !$0 ? ScreenManager().goToOnboarding(viewcontroller) : self.deleteFolderDataManager(folderId, viewcontroller)
                    }
                default:
                    print(error.responseCode)
                }
            }
        }
    }
    // MARK: - 폴더 리스트 조회
    func getFolderListDataManager(_ viewcontroller: SetFolderBottomSheetViewController) {
        AF.request(Storage().BaseURL + "/folder/list",
                           method: .get,
                           parameters: nil,
                           headers: APIManager().getHeader())
            .validate()
            .responseDecodable(of: [FolderListModel].self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.getFolderListAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
//                case 429:
//                    viewcontroller.getFolderListAPIFail()
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager() {
                        !$0 ? ScreenManager().goToOnboarding(viewcontroller) : self.getFolderListDataManager(viewcontroller)
                    }
                default:
                    print(error.responseCode)
                }
            }
        }
    }
    // MARK: - 폴더 내 아이템 조회
    func getFolderDetailDataManager(_ folderId: Int, _ viewcontroller: FolderDetailViewController) {
        AF.request(Storage().BaseURL + "/folder/item/\(folderId)",
                           method: .get,
                           parameters: nil,
                           headers: APIManager().getHeader())
            .validate()
            .responseDecodable(of: [WishListModel].self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.getFolderDetailAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
//                case 429:
//                    viewcontroller.getFolderDetailAPIFail()
                case 404:
                    viewcontroller.noWishList()
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager() {
                        !$0 ? ScreenManager().goToOnboarding(viewcontroller) : self.getFolderDetailDataManager(folderId, viewcontroller)
                    }
                default:
                    print(error.responseCode)
                }
            }
        }
    }
    // MARK: - 아이템의 폴더 수정
    func modifyItemFolderDataManager(_ itemId: Int, _ folderId: Int, _ viewcontroller: SetFolderBottomSheetViewController) {
        AF.request(Storage().BaseURL + "/item/\(itemId)/folder/\(folderId)",
                           method: .put,
                           parameters: nil,
                           headers: APIManager().getHeader())
            .validate()
            .responseDecodable(of: APIModel<ResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.modifyItemFolderAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 500:
                    DispatchQueue.main.async {
                        ErrorBar(viewcontroller)
                    }
                case 401:
                    RefreshDataManager().refreshDataManager() {
                        !$0 ? ScreenManager().goToOnboarding(viewcontroller) : self.modifyItemFolderDataManager(itemId, folderId, viewcontroller)
                    }
                default:
                    print(error.responseCode)
                }
            }
        }
    }
}
