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
        let BaseURL = defaults?.string(forKey: "url") ?? ""
        let token = defaults?.string(forKey: "accessToken") ?? ""
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
                case 404:
                    viewcontroller.getItemDataAPIFail()
                case 429:
                    viewcontroller.getFolderListAPIFail()
                default:
                    print(error.localizedDescription)
                    print(error.responseCode)
                }
            }
        }
    }
    // MARK: - 아이템 간편 등록
    // MARK: - 모든 데이터가 존재하는 경우 (폴더O, 알림O)
    func uploadItemDataManager(_ folderId: Int,
                               _ photo: UIImage,
                               _ itemName: String,
                               _ itemPrice: String,
                               _ itemURL: String,
                               _ itemMemo: String,
                               _ itemNotificationType: String,
                               _ itemNotificationDate: String,
                               _ viewcontroller: ShareViewController) {
        let BaseURL = defaults?.string(forKey: "url") ?? ""
        let token = defaults?.string(forKey: "accessToken") ?? ""
        let multiHeader: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization": "Bearer " + token
        ]
        
        let uploadItemUrl = BaseURL + "/item"
        let body : Parameters = [
                        "folder_id" : folderId,
                        "item_name" : itemName,
                        "item_price" : itemPrice,
                        "item_url" : itemURL,
                        "item_memo" : itemMemo,
                        "item_notification_type" : itemNotificationType,
                        "item_notification_date" : itemNotificationDate,
                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
        AF.upload(multipartFormData: { (multipart) in
            if let imageData = photo.jpegData(compressionQuality: 0.8) {
                multipart.append(imageData, withName: "item_img", fileName: "photo.jpg", mimeType: "image/jpeg")
                //이미지 데이터를 POST할 데이터에 덧붙임
            }
            for (key, value) in body {
                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
            }
        }
        ,to: URL(string: uploadItemUrl)!    //전달할 url
        ,method: .post        //전달 방식
        ,headers: multiHeader) //헤더
        .responseData { response in
            switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(APIModel<ResultModel>.self, from: data)
                        viewcontroller.uploadItemAPISuccess(result)
                        print(result)
                    } catch {
                        print("error", data)
                    }
                case let .failure(error): // 요청 x
                print(error.responseCode)
            }
        }
    }
    // MARK: - (폴더X, 알림O)
    func uploadItemDataManager(_ photo: UIImage,
                               _ itemName: String,
                               _ itemPrice: String,
                               _ itemURL: String,
                               _ itemMemo: String,
                               _ itemNotificationType: String,
                               _ itemNotificationDate: String,
                               _ viewcontroller: ShareViewController) {
        let BaseURL = defaults?.string(forKey: "url") ?? ""
        let token = defaults?.string(forKey: "accessToken") ?? ""
        let multiHeader: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization": "Bearer " + token
        ]
        
        let uploadItemUrl = BaseURL + "/item"
        let body : Parameters = [
                        "item_name" : itemName,
                        "item_price" : itemPrice,
                        "item_url" : itemURL,
                        "item_memo" : itemMemo,
                        "item_notification_type" : itemNotificationType,
                        "item_notification_date" : itemNotificationDate,
                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
        AF.upload(multipartFormData: { (multipart) in
            if let imageData = photo.jpegData(compressionQuality: 0.8) {
                multipart.append(imageData, withName: "item_img", fileName: "photo.jpg", mimeType: "image/jpeg")
                //이미지 데이터를 POST할 데이터에 덧붙임
            }
            for (key, value) in body {
                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
            }
        }
        ,to: URL(string: uploadItemUrl)!    //전달할 url
        ,method: .post        //전달 방식
        ,headers: multiHeader) //헤더
        .responseData { response in
            switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(APIModel<ResultModel>.self, from: data)
                        viewcontroller.uploadItemAPISuccess(result)
                        print(result)
                    } catch {
                        print("error", data)
                    }
                case let .failure(error): // 요청 x
                print(error.responseCode)
            }
        }
    }
    // MARK: - 날짜 설정 하지 않은 경우 (폴더O, 알림X)
    func uploadItemDataManager(_ folderId: Int,
                               _ photo: UIImage,
                               _ itemName: String,
                               _ itemPrice: String,
                               _ itemURL: String,
                               _ itemMemo: String,
                               _ viewcontroller: ShareViewController) {
        let BaseURL = defaults?.string(forKey: "url") ?? ""
        let token = defaults?.string(forKey: "accessToken") ?? ""
        let multiHeader: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization": "Bearer " + token
        ]
        
        let uploadItemUrl = BaseURL + "/item"
        let body : Parameters = [
                        "folder_id" : folderId,
                        "item_name" : itemName,
                        "item_price" : itemPrice,
                        "item_url" : itemURL,
                        "item_memo" : itemMemo,
                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
        AF.upload(multipartFormData: { (multipart) in
            if let imageData = photo.jpegData(compressionQuality: 0.8) {
                multipart.append(imageData, withName: "item_img", fileName: "photo.jpg", mimeType: "image/jpeg")
                //이미지 데이터를 POST할 데이터에 덧붙임
            }
            for (key, value) in body {
                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
            }
        }
        ,to: URL(string: uploadItemUrl)!    //전달할 url
        ,method: .post        //전달 방식
        ,headers: multiHeader) //헤더
        .responseData { response in
            switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(APIModel<ResultModel>.self, from: data)
                        viewcontroller.uploadItemAPISuccess(result)
                        print(result)
                    } catch {
                        let str = String(decoding: data, as: UTF8.self)
                        print("error", str)
                    }
                case let .failure(error): // 요청 x
                print(error.responseCode)
            }
        }
    }
    // MARK: - 날짜 설정 하지 않은 경우 (폴더X, 알림X)
    func uploadItemDataManager(_ photo: UIImage,
                               _ itemName: String,
                               _ itemPrice: String,
                               _ itemURL: String,
                               _ itemMemo: String,
                               _ viewcontroller: ShareViewController) {
        let BaseURL = defaults?.string(forKey: "url") ?? ""
        let token = defaults?.string(forKey: "accessToken") ?? ""
        let multiHeader: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization": "Bearer " + token
        ]
        
        let uploadItemUrl = BaseURL + "/item"
        let body : Parameters = [
                        "item_name" : itemName,
                        "item_price" : itemPrice,
                        "item_url" : itemURL,
                        "item_memo" : itemMemo,
                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
        AF.upload(multipartFormData: { (multipart) in
            if let imageData = photo.jpegData(compressionQuality: 0.8) {
                multipart.append(imageData, withName: "item_img", fileName: "photo.jpg", mimeType: "image/jpeg")
                //이미지 데이터를 POST할 데이터에 덧붙임
            }
            for (key, value) in body {
                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
            }
        }
        ,to: URL(string: uploadItemUrl)!    //전달할 url
        ,method: .post        //전달 방식
        ,headers: multiHeader) //헤더
        .responseData { response in
            switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(APIModel<ResultModel>.self, from: data)
                        viewcontroller.uploadItemAPISuccess(result)
                        print(result)
                    } catch {
                        let str = String(decoding: data, as: UTF8.self)
                        print("error", str)
                    }
                case let .failure(error): // 요청 x
                print(error.responseCode)
            }
        }
    }
}
