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
//    // MARK: - 아이템 직접 추가 - 모든 데이터가 존재하는 경우
//    func uploadItemDataManager(_ folderId: Int,
//                               _ photo: UIImage,
//                               _ itemName: String,
//                               _ itemPrice: String,
//                               _ itemURL: String,
//                               _ itemMemo: String,
//                               _ itemNotificationType: String,
//                               _ itemNotificationDate: String,
//                               _ viewcontroller: UploadItemViewController) {
//
//        let uploadItemUrl = Storage().BaseURL + "/item"
//        let body : Parameters = [
//                        "folder_id" : folderId,
//                        "item_name" : itemName,
//                        "item_price" : itemPrice,
//                        "item_url" : itemURL,
//                        "item_memo" : itemMemo,
//                        "item_notification_type" : itemNotificationType,
//                        "item_notification_date" : itemNotificationDate,
//                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
//        AF.upload(multipartFormData: { (multipart) in
//            if let imageData = photo.jpegData(compressionQuality: 0.5) {
//                multipart.append(imageData, withName: "item_img", fileName: "photo.jpg", mimeType: "image/jpeg")
//                //이미지 데이터를 POST할 데이터에 덧붙임
//            }
//            for (key, value) in body {
//                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
//                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
//            }
//        }
//        ,to: URL(string: uploadItemUrl)!    //전달할 url
//        ,method: .post        //전달 방식
//        ,headers: multiHeader) //헤더
//        .responseData { response in
//            switch response.result {
//                case let .success(data):
//                    do {
//                        let decoder = JSONDecoder()
//                        let result = try decoder.decode(APIModel<TokenResultModel>.self, from: data)
//                        viewcontroller.uploadItemAPISuccess(result)
//                        print(result)
//                    } catch {
//                        print("error", data)
//                    }
//                case let .failure(error): // 요청 x
//                print(error.responseCode)
//            }
//        }
//    }
//    // MARK: - 아이템 직접 추가 - 날짜 설정은 하지 않은 경우
//    func uploadItemDataManager(_ folderId: Int,
//                               _ photo: UIImage,
//                               _ itemName: String,
//                               _ itemPrice: String,
//                               _ itemURL: String,
//                               _ itemMemo: String,
//                               _ viewcontroller: UploadItemViewController) {
//
//        let uploadItemUrl = Storage().BaseURL + "/item"
//        let body : Parameters = [
//                        "folder_id" : folderId,
//                        "item_name" : itemName,
//                        "item_price" : itemPrice,
//                        "item_url" : itemURL,
//                        "item_memo" : itemMemo,
//                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
//        AF.upload(multipartFormData: { (multipart) in
//            if let imageData = photo.jpegData(compressionQuality: 0.5) {
//                multipart.append(imageData, withName: "item_img", fileName: "photo.jpg", mimeType: "image/jpeg")
//                //이미지 데이터를 POST할 데이터에 덧붙임
//            }
//            for (key, value) in body {
//                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
//                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
//            }
//        }
//        ,to: URL(string: uploadItemUrl)!    //전달할 url
//        ,method: .post        //전달 방식
//        ,headers: multiHeader) //헤더
//        .responseData { response in
//            switch response.result {
//                case let .success(data):
//                    do {
//                        let decoder = JSONDecoder()
//                        let result = try decoder.decode(APIModel<TokenResultModel>.self, from: data)
//                        viewcontroller.uploadItemAPISuccess(result)
//                        print(result)
//                    } catch {
//                        let str = String(decoding: data, as: UTF8.self)
//                        print("error", str)
//                    }
//                case let .failure(error): // 요청 x
//                if error.responseCode == 401 {
//                    RefreshDataManager().refreshDataManager()
//                }
//                print(error.responseCode)
//            }
//        }
//    }
//    // MARK: - 아이템 추가 - 폴더가 없고, 알림설정은 한 경우
//    func uploadItemDataManager(_ photo: UIImage,
//                               _ itemName: String,
//                               _ itemPrice: String,
//                               _ itemURL: String,
//                               _ itemMemo: String,
//                               _ itemNotificationType: String,
//                               _ itemNotificationDate: String,
//                               _ viewcontroller: UploadItemViewController) {
//
//        let uploadItemUrl = Storage().BaseURL + "/item"
//        let body : Parameters = [
//                        "item_name" : itemName,
//                        "item_price" : itemPrice,
//                        "item_url" : itemURL,
//                        "item_memo" : itemMemo,
//                        "item_notification_type" : itemNotificationType,
//                        "item_notification_date" : itemNotificationDate,
//                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
//        AF.upload(multipartFormData: { (multipart) in
//            if let imageData = photo.jpegData(compressionQuality: 0.5) {
//                multipart.append(imageData, withName: "item_img", fileName: "photo.jpg", mimeType: "image/jpeg")
//                //이미지 데이터를 POST할 데이터에 덧붙임
//            }
//            for (key, value) in body {
//                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
//                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
//            }
//        }
//        ,to: URL(string: uploadItemUrl)!    //전달할 url
//        ,method: .post        //전달 방식
//        ,headers: multiHeader) //헤더
//        .responseData { response in
//            switch response.result {
//                case let .success(data):
//                    do {
//                        let decoder = JSONDecoder()
//                        let result = try decoder.decode(APIModel<TokenResultModel>.self, from: data)
//                        viewcontroller.uploadItemAPISuccess(result)
//                        print(result)
//                    } catch {
//                        let str = String(decoding: data, as: UTF8.self)
//                        print("error", str)
//                    }
//                case let .failure(error): // 요청 x
//                    print(error.responseCode)
//                    if error.responseCode == 401 {
//                        RefreshDataManager().refreshDataManager()
//                    }
//            }
//        }
//    }
//    // MARK: - 아이템 직접 추가 - 데이터가 일부만 존재하는 경우
//    func uploadItemDataManager(_ photo: UIImage,
//                               _ itemName: String,
//                               _ itemPrice: String,
//                               _ itemURL: String,
//                               _ itemMemo: String,
//                               _ viewcontroller: UploadItemViewController) {
//
//        let uploadItemUrl = Storage().BaseURL + "/item"
//        let body : Parameters = [
//                        "item_name" : itemName,
//                        "item_price" : itemPrice,
//                        "item_url" : itemURL,
//                        "item_memo" : itemMemo,
//                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
//        AF.upload(multipartFormData: { (multipart) in
//            if let imageData = photo.jpegData(compressionQuality: 0.5) {
//                multipart.append(imageData, withName: "item_img", fileName: "photo.jpg", mimeType: "image/jpeg")
//                //이미지 데이터를 POST할 데이터에 덧붙임
//            }
//            for (key, value) in body {
//                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
//                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
//            }
//        }
//        ,to: URL(string: uploadItemUrl)!    //전달할 url
//        ,method: .post        //전달 방식
//        ,headers: multiHeader) //헤더
//        .responseData { response in
//            switch response.result {
//                case let .success(data):
//                    do {
//                        let decoder = JSONDecoder()
//                        let result = try decoder.decode(APIModel<TokenResultModel>.self, from: data)
//                        viewcontroller.uploadItemAPISuccess(result)
//                        print(result)
//                    } catch {
////                        print("error", data) //error 38bytes
//                        let str = String(decoding: data, as: UTF8.self)
//                        print("error", str)
//                    }
//                case let .failure(error): // 요청 x
//                    if error.responseCode == 401 {
//                        RefreshDataManager().refreshDataManager()
//                    }
//                print(error.responseCode)
//            }
//        }
//    }
//    // MARK: - 아이템 수정 - 모든 데이터가 존재하는 경우
//    func modifyItemDataManager(_ folderId: Int,
//                               _ photo: UIImage,
//                               _ itemName: String,
//                               _ itemPrice: String,
//                               _ itemURL: String,
//                               _ itemMemo: String,
//                               _ itemNotificationType: String,
//                               _ itemNotificationDate: String,
//                               _ itemId: Int,
//                               _ viewcontroller: UploadItemViewController) {
//
//        let uploadItemUrl = Storage().BaseURL + "/item/\(itemId)"
//        let body : Parameters = [
//                        "folder_id" : folderId,
//                        "item_name" : itemName,
//                        "item_price" : itemPrice,
//                        "item_url" : itemURL,
//                        "item_memo" : itemMemo,
//                        "item_notification_type" : itemNotificationType,
//                        "item_notification_date" : itemNotificationDate,
//                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
//        AF.upload(multipartFormData: { (multipart) in
//            if let imageData = photo.jpegData(compressionQuality: 0.5) {
//                multipart.append(imageData, withName: "item_img", fileName: "photo.jpg", mimeType: "image/jpeg")
//                //이미지 데이터를 POST할 데이터에 덧붙임
//            }
//            for (key, value) in body {
//                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
//                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
//            }
//        }
//        ,to: URL(string: uploadItemUrl)!    //전달할 url
//        ,method: .put        //전달 방식
//        ,headers: multiHeader) //헤더
//        .responseData { response in
//            switch response.result {
//                case let .success(data):
//                    do {
//                        let decoder = JSONDecoder()
//                        let result = try decoder.decode(APIModel<TokenResultModel>.self, from: data)
//                        viewcontroller.modifyItemAPISuccess(result)
//                        print(result)
//                    } catch {
//                        print("error", data)
//                    }
//                case let .failure(error): // 요청 x
//                    if error.responseCode == 401 {
//                        RefreshDataManager().refreshDataManager()
//                    }
//                print(error.responseCode)
//            }
//        }
//    }
//    // MARK: - 아이템 수정 - 날짜 설정은 하지 않은 경우
//    func modifyItemDataManager(_ folderId: Int,
//                               _ photo: UIImage,
//                               _ itemName: String,
//                               _ itemPrice: String,
//                               _ itemURL: String,
//                               _ itemMemo: String,
//                               _ itemId: Int,
//                               _ viewcontroller: UploadItemViewController) {
//
//        let uploadItemUrl = Storage().BaseURL + "/item/\(itemId)"
//        let body : Parameters = [
//                        "folder_id" : folderId,
//                        "item_name" : itemName,
//                        "item_price" : itemPrice,
//                        "item_url" : itemURL,
//                        "item_memo" : itemMemo,
//                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
//        AF.upload(multipartFormData: { (multipart) in
//            if let imageData = photo.jpegData(compressionQuality: 0.5) {
//                multipart.append(imageData, withName: "item_img", fileName: "photo.jpg", mimeType: "image/jpeg")
//                //이미지 데이터를 POST할 데이터에 덧붙임
//            }
//            for (key, value) in body {
//                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
//                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
//            }
//        }
//        ,to: URL(string: uploadItemUrl)!    //전달할 url
//        ,method: .put        //전달 방식
//        ,headers: multiHeader) //헤더
//        .responseData { response in
//            switch response.result {
//                case let .success(data):
//                    do {
//                        let decoder = JSONDecoder()
//                        let result = try decoder.decode(APIModel<TokenResultModel>.self, from: data)
//                        viewcontroller.modifyItemAPISuccess(result)
//                        print(result)
//                    } catch {
//                        let str = String(decoding: data, as: UTF8.self)
//                        print("error", str)
//                    }
//                case let .failure(error): // 요청 x
//                    if error.responseCode == 401 {
//                        RefreshDataManager().refreshDataManager()
//                    }
//                print(error.responseCode)
//            }
//        }
//    }
//    // MARK: - 아이템 수정 - 폴더가 없고, 알림설정은 한 경우
//    func modifyItemDataManager(_ photo: UIImage,
//                               _ itemName: String,
//                               _ itemPrice: String,
//                               _ itemURL: String,
//                               _ itemMemo: String,
//                               _ itemNotificationType: String,
//                               _ itemNotificationDate: String,
//                               _ itemId: Int,
//                               _ viewcontroller: UploadItemViewController) {
//
//        let uploadItemUrl = Storage().BaseURL + "/item/\(itemId)"
//        let body : Parameters = [
//                        "item_name" : itemName,
//                        "item_price" : itemPrice,
//                        "item_url" : itemURL,
//                        "item_memo" : itemMemo,
//                        "item_notification_type" : itemNotificationType,
//                        "item_notification_date" : itemNotificationDate,
//                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
//        AF.upload(multipartFormData: { (multipart) in
//            if let imageData = photo.jpegData(compressionQuality: 0.5) {
//                multipart.append(imageData, withName: "item_img", fileName: "photo.jpg", mimeType: "image/jpeg")
//                //이미지 데이터를 POST할 데이터에 덧붙임
//            }
//            for (key, value) in body {
//                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
//                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
//            }
//        }
//        ,to: URL(string: uploadItemUrl)!    //전달할 url
//        ,method: .put        //전달 방식
//        ,headers: multiHeader) //헤더
//        .responseData { response in
//            switch response.result {
//                case let .success(data):
//                    do {
//                        let decoder = JSONDecoder()
//                        let result = try decoder.decode(APIModel<TokenResultModel>.self, from: data)
//                        viewcontroller.modifyItemAPISuccess(result)
//                        print(result)
//                    } catch {
//                        let str = String(decoding: data, as: UTF8.self)
//                        print("error", str)
//                    }
//                case let .failure(error): // 요청 x
//                    if error.responseCode == 401 {
//                        RefreshDataManager().refreshDataManager()
//                    }
//                print(error.responseCode)
//            }
//        }
//    }
//    // MARK: - 아이템 수정 - 데이터가 일부만 존재하는 경우
//    func modifyItemDataManager(_ photo: UIImage,
//                               _ itemName: String,
//                               _ itemPrice: String,
//                               _ itemURL: String,
//                               _ itemMemo: String,
//                               _ itemId: Int,
//                               _ viewcontroller: UploadItemViewController) {
//
//        let uploadItemUrl = Storage().BaseURL + "/item/\(itemId)"
//        let body : Parameters = [
//                        "item_name" : itemName,
//                        "item_price" : itemPrice,
//                        "item_url" : itemURL,
//                        "item_memo" : itemMemo,
//                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
//        AF.upload(multipartFormData: { (multipart) in
//            if let imageData = photo.jpegData(compressionQuality: 0.5) {
//                multipart.append(imageData, withName: "item_img", fileName: "photo.jpg", mimeType: "image/jpeg")
//                //이미지 데이터를 POST할 데이터에 덧붙임
//            }
//            for (key, value) in body {
//                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
//                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
//            }
//        }
//        ,to: URL(string: uploadItemUrl)!    //전달할 url
//        ,method: .put        //전달 방식
//        ,headers: multiHeader) //헤더
//        .responseData { response in
//            switch response.result {
//                case let .success(data):
//                    do {
//                        let decoder = JSONDecoder()
//                        let result = try decoder.decode(APIModel<TokenResultModel>.self, from: data)
//                        viewcontroller.modifyItemAPISuccess(result)
//                        print(result)
//                    } catch {
////                        print("error", data) //error 38bytes
//                        let str = String(decoding: data, as: UTF8.self)
//                        print("error", str)
//                    }
//                case let .failure(error):
//                    if error.responseCode == 401 {
//                        RefreshDataManager().refreshDataManager()
//                    }
//                print(error.responseCode)
//            }
//        }
//    }
}
