//
//  ModifyProfileDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/27.
//

import Foundation
import Alamofire

class ModifyProfileDataManager {
    let header = APIManager().getHeader()
    
    // MARK: - 사용자 프로필 변경
    // MARK: 닉네임만 수정
    func modifyProfileDataManager(_ parameter: ModifyProfileInputNickname, _ viewcontroller: ModifyProfileViewController) {
        AF.request(Storage().BaseURL + "/user",
                           method: .put,
                           parameters: parameter,
                           encoder: JSONParameterEncoder.default,
                           headers: APIManager().getHeader())
            .validate()
            .responseDecodable(of: APIModel<TokenResultModel>.self) { response in
            switch response.result {
            case .success(let result):
                viewcontroller.modifyProfileAPISuccess(result)
            case .failure(let error):
                let statusCode = error.responseCode
                switch statusCode {
                case 500:
                   DispatchQueue.main.async {
                       ErrorBar(viewcontroller)
                   }
                case 401:
                    RefreshDataManager().refreshDataManager() {
                        !$0 ? ScreenManager().goToOnboarding(viewcontroller) : self.modifyProfileDataManager(parameter, viewcontroller)
                    }
                default:
                    print(error.responseCode)
                }
            }
        }
    }
    //multipart 업로드
    //HTTP 헤더
    // MARK: 닉네임 & 프로필 사진
    let multiHeader = APIManager().getMultipartHeader()
    func modifyProfileDataManager(_ nickname: String, _ photo: UIImage, _ viewcontroller: ModifyProfileViewController) {
        let modifyUrl = Storage().BaseURL + "/user"
        let body : Parameters = [
                        "nickname" : nickname,
                    ]    //PUT 함수로 전달할 String 데이터, 이미지 데이터는 제외하고 구성
        AF.upload(multipartFormData: { (multipart) in
            if let imageData = photo.jpegData(compressionQuality: 0.5) {
                multipart.append(imageData, withName: "profile_img", fileName: "photo.jpg", mimeType: "image/jpeg")
                //이미지 데이터를 POST할 데이터에 덧붙임
            }
            for (key, value) in body {
                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
                //이미지 데이터 외에 같이 전달할 데이터 (여기서는 idx, name, introduction 등)
            }
        }
        ,to: URL(string: modifyUrl)!    //전달할 url
        ,method: .put        //전달 방식
        ,headers: multiHeader) //헤더
        .responseData { response in
            switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(APIModel<TokenResultModel>.self, from: data)
                        viewcontroller.modifyProfileAPISuccess(result)
                        print(result)
                    } catch {
                        print("error", data)
                    }
                case let .failure(error): // 요청 x
                    print(error.responseCode)
                    if error.responseCode == 401 {
                        RefreshDataManager().refreshDataManager() {
                            !$0 ? ScreenManager().goToOnboarding(viewcontroller) : self.modifyProfileDataManager(nickname, photo, viewcontroller)
                        }
                    }
            }
        }
    }
    // MARK: 프로필 이미지만 수정
    func modifyProfileDataManager(_ photo: UIImage, _ viewcontroller: ModifyProfileViewController) {
        let modifyUrl = Storage().BaseURL + "/user"
        AF.upload(multipartFormData: { (multipart) in
            if let imageData = photo.jpegData(compressionQuality: 0.5) {
                multipart.append(imageData, withName: "profile_img", fileName: "photo.jpg", mimeType: "image/jpeg")
                //이미지 데이터를 POST할 데이터에 덧붙임
            }
        }
        ,to: URL(string: modifyUrl)!    //전달할 url
        ,method: .put        //전달 방식
        ,headers: multiHeader) //헤더
        .responseData { response in
            switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(APIModel<TokenResultModel>.self, from: data)
                        viewcontroller.modifyProfileAPISuccess(result)
                        print(result)
                    } catch {
                        print("error", data)
                    }
                case let .failure(error): // 요청 x
                    if error.responseCode == 401 {
                        RefreshDataManager().refreshDataManager() {
                            !$0 ? ScreenManager().goToOnboarding(viewcontroller) : self.modifyProfileDataManager(photo, viewcontroller)
                        }
                    }
                print(error.responseCode)
            }
        }
    }
}
