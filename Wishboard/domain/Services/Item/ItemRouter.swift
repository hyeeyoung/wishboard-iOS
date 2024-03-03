//
//  ItemRouter.swift
//  Wishboard
//
//  Created by gomin on 2023/03/24.
//

import Foundation
import Moya
import UIKit

struct MoyaItemInput {
    let folderId: Int?
    let photo: UIImage
    let itemName: String
    let itemPrice: String
    let itemURL: String?
    let itemMemo: String?
    let itemNotificationType: String?
    let itemNotificationDate: String?
}

enum ItemRouter: BaseRouter{
    case uploadItem(param: MoyaItemInput)
    case modifyItem(param: MoyaItemInput, id: Int)
    
}

extension ItemRouter{
    
    var path: String {
        switch self {
        case .uploadItem:
            return HTTPMethodURL.POST.uploadItem
        case .modifyItem(_, let id):
            return HTTPMethodURL.PUT.modifyITem + "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .uploadItem:
            return .post
        case .modifyItem:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .uploadItem(let param):
            let formData = makeMultipartFormData(param: param)
            return .uploadMultipart(formData)
        case .modifyItem(let param, let id):
            let formData = makeMultipartFormData(param: param)
            return .uploadCompositeMultipart(formData, urlParameters: ["item_id": id])
        }
    }
    
    var headers: [String: String]? {
        let token = UserManager.accessToken ?? ""
        return ["Content-Type": "multipart/form-data",
                "Authorization": "Bearer " + token]
    }
    
    func makeMultipartFormData(param: MoyaItemInput) -> [Moya.MultipartFormData] {
        let itemNameData = MultipartFormData(provider: .data(param.itemName.data(using: String.Encoding.utf8) ?? Data()), name: "item_name")
        let itemPriceData = MultipartFormData(provider: .data(param.itemPrice.data(using: String.Encoding.utf8) ?? Data()), name: "item_price")
        let itemURLData = MultipartFormData(provider: .data(param.itemURL!.data(using: String.Encoding.utf8) ?? Data()), name: "item_url")
        let itemMemoData = MultipartFormData(provider: .data(param.itemMemo!.data(using: String.Encoding.utf8) ?? Data()), name: "item_memo")
        
        var folderIdData: MultipartFormData?
        var itemNotificationTypeData: MultipartFormData?
        var itemNotificationDateData: MultipartFormData?
        
        if let folderId = param.folderId {
            folderIdData = MultipartFormData(provider: .data(String(folderId ?? -1).data(using: String.Encoding.utf8) ?? Data()), name: "folder_id")
        }
        if let notificationType = param.itemNotificationType {
            itemNotificationTypeData = MultipartFormData(provider: .data(notificationType.data(using: String.Encoding.utf8) ?? Data()), name: "item_notification_type")
        }
        if let notificationDate = param.itemNotificationDate {
            let itemNotificationDate = notificationDate + ":00"
            itemNotificationDateData = MultipartFormData(provider: .data(itemNotificationDate.data(using: String.Encoding.utf8) ?? Data()), name: "item_notification_date")
        }

        let imageData = param.photo.resizeImageIfNeeded().jpegData(compressionQuality: 1.0) ?? Data()
        let imageMultipartFormData = MultipartFormData(provider: .data(imageData), name: "item_img", fileName: "item.jpeg", mimeType: "image/jpeg")
        
        var formData: [Moya.MultipartFormData] = [imageMultipartFormData]
        formData.append(itemNameData)
        formData.append(itemPriceData)
        formData.append(itemURLData)
        formData.append(itemMemoData)
        if let folderIdData = folderIdData {
            formData.append(folderIdData)
        }
        if let itemNotificationTypeData = itemNotificationTypeData {
            formData.append(itemNotificationTypeData)
        }
        if let itemNotificationDateData = itemNotificationDateData {
            formData.append(itemNotificationDateData)
        }
        
        return formData
    }
}
