//
//  MypageViewModel.swift
//  Wishboard
//
//  Created by gomin on 2023/09/10.


import UIKit
import RxCocoa
import RxSwift

final class MyPageViewModel: BaseViewModel {
    
    // PublishSubject를 사용하여 로그아웃 버튼 클릭 이벤트를 수동으로 처리
    let logoutButtonTapSubject = PublishSubject<Void>()

    // 외부에서 logoutButtonTapSubject이 호출되었을 때만 logoutButtonTap이 활성화됨.
    var logoutButtonTap: Observable<Void> {
        return logoutButtonTapSubject.asObservable()
    }
    
    var disposeBag = DisposeBag()
    
    struct Input {
        var notiSwitchObservable: Observable<Bool>
    }
    
    struct Output {
        var getUserInfoResponse: Driver<GetUserInfoModel>
        var setNotificationResponse: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        
        // 사용자 정보 조회 api 호출 및 응답 처리
        let userInfoObservable = MypageDataManager2.shared.getUserInfoDataManager2()
        let userInfoDriver = userInfoObservable
            .asDriver(onErrorJustReturn: GetUserInfoModel(email: "",
                                                          profile_img_url: nil,
                                                          nickname: nil,
                                                          push_state: -1))
        
        // 알림 토글 여부에 따른 api 호출
        let notiResponse = input.notiSwitchObservable
            .flatMapLatest {
                return MypageDataManager2.shared.switchNotificationDataManager($0)
            }
            .asDriver(onErrorJustReturn: false)
        

        return Output(getUserInfoResponse: userInfoDriver,
                      setNotificationResponse: notiResponse)
    }
    
    /// 로그아웃 버튼 클릭 시
    func callLogoutAPI() -> Driver<Bool> {
        let logoutResponse = logoutButtonTap
            .flatMapLatest {
                return MypageDataManager2.shared.logoutDataManager()
            }
            .asDriver(onErrorJustReturn: false)
        
        return logoutResponse
    }
    
}
