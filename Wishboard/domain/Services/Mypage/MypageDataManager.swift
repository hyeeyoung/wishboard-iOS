//
//  MypageDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/27.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class MypageDataManager {
    let header = APIManager().getHeader()
    
    // MARK: - 사용자 정보 조회
    func getUserInfoDataManager(_ viewcontroller: MyPageViewController) {
        
        let url = Storage().BaseURL + "/user"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .get, viewcontroller)
        
        AlamofireBaseService.shared.responseDecoded(request, [GetUserInfoModel].self) { result in
            viewcontroller.getUserInfoAPISuccess(result)
        }
        
    }
    // MARK: - 알림 토글 수정
    /// 분기처리: 마이페이지 / 앱 이용방법 후 (회원가입 이후)
    func switchNotificationDataManager(_ isOn: Bool, _ viewcontroller: UIViewController) {
        
        let url = Storage().BaseURL + "/user/push-state/\(isOn)"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .put, viewcontroller)
        
        AlamofireBaseService.shared.responseDecoded(request, APIModel<TokenResultModel>.self) { result in
            if let viewcontroller = viewcontroller as? MyPageViewController {
//                viewcontroller.switchNotificationAPISuccess(result)
            } else if let viewcontroller = viewcontroller as? HomeViewController {
                viewcontroller.switchNotificationAPISuccess(result)
            }
        }
    }
    // MARK: - 회원 탈퇴
    func deleteUserDataManager(_ viewcontroller: PopUpDeleteUserViewController) {
        let url = Storage().BaseURL + "/user"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .delete, viewcontroller)
        
        AlamofireBaseService.shared.responseDecoded(request, APIModel<TokenResultModel>.self) { result in
            viewcontroller.deleteUserAPISuccess(result)
        }
    }
    // MARK: - 로그아웃
    func logoutDataManager(_ viewcontroller: MyPageViewController) {
        let url = Storage().BaseURL + "/auth/logout"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .post, viewcontroller)
        
        AlamofireBaseService.shared.responseDecoded(request, APIModel<ResultModel>.self) { result in
            viewcontroller.logoutAPISuccess()
        }
        
    }
}


final class MypageDataManager2 {
    static let shared = MypageDataManager2()
    let header = APIManager().getHeader()
    
    private init() { }
    
    // MARK: - 사용자 정보 조회
    // 사용자 정보 조회
    func getUserInfoDataManager2() -> Observable<GetUserInfoModel> {
        let url = Storage().BaseURL + "/user"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .get, nil)
        
        return Observable.create { observer in
            AlamofireBaseService.shared.responseDecoded(request, [GetUserInfoModel].self) { result in
                if let userInfo = result.first {
                    observer.onNext(userInfo) // 응답 성공 시 데이터를 onNext로 전달
                    observer.onCompleted()
                } else {
                    print("사용자 정보 조회 api Error")
                }
            }
            
            return Disposables.create()
        }
    }
    // 마이페이지 알림 여부 토글
    func switchNotificationDataManager(_ isOn: Bool) -> Observable<Bool> {
        
        let url = Storage().BaseURL + "/user/push-state/\(isOn)"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .put, nil)
        
        return Observable.create { observer in
            AlamofireBaseService.shared.responseDecoded(request, APIModel<TokenResultModel>.self) { result in
                let response = result.success
                observer.onNext(response)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    // 로그아웃
    func logoutDataManager() -> Observable<Bool> {
        let url = Storage().BaseURL + "/auth/logout"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .post, nil)
        
        return Observable.create { observer in
            AlamofireBaseService.shared.responseDecoded(request, APIModel<ResultModel>.self) { result in
                let response = result.success
                observer.onNext(response)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
