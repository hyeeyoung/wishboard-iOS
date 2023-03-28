//
//  ItemService.swift
//  Wishboard
//
//  Created by gomin on 2023/03/24.
//

import Foundation
import Moya

final class ItemService{
    static let shared = ItemService()
    private init() { }
    let provider = MultiMoyaService(plugins: [MoyaLoggerPlugin()])
}

extension ItemService{
    
    func uploadItem(model: MoyaItemInput, completion: @escaping (Result<APIModel<ResultModel>, Error>) -> Void) {
        provider.requestDecoded(ItemRouter.uploadItem(param: model)) { response in
            completion(response)
        }
    }
    func modifyItem(model: MoyaItemInput, id: Int, completion: @escaping (Result<APIModel<ResultModel>, Error>) -> Void) {
        provider.requestDecoded(ItemRouter.modifyItem(param: model, id: id)) { response in
            completion(response)
        }
    }
}

