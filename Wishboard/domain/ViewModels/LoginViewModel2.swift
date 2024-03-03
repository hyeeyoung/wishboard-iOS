//
//  LoginViewModel2.swift
//  Wishboard
//
//  Created by gomin on 2023/09/05.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class LoginViewModel2: BaseViewModel {
    
    var email: String?
    var password: String?
    
    struct Input {
        var emailText: Observable<String>
        var passwordText: Observable<String>
        var loginButtonEvent: ControlEvent<Void>
    }
    
    struct Output {
        var processEmailText: Observable<String>
        var processPwText: Observable<String>
        var buttonActivate: Driver<Bool>
        var loginResponse: Observable<Bool>
    }
    
    
    func transform(_ input: Input) -> Output {
        // 이메일과 비밀번호 텍스트의 띄어쓰기 제거
        let emailTextObservable = input.emailText
            .map{ text in
                return text.replacingOccurrences(of: " ", with: "")
            }.do{
                self.email = $0
            }
        
        let pwTextObservable = input.passwordText
            .map{ text in
                return text.replacingOccurrences(of: " ", with: "")
            }.do{
                self.password = $0
            }
        // 이메일과 비밀번호의 유효성 검사
        let validEmailText = emailTextObservable
            .map {
                return $0.checkEmail()
            }
        let validPwText = pwTextObservable
            .map {
                return $0.checkPassword()
            }
        // 버튼의 활성화 유무
        let combineObservable = Observable<Any>.combineLatest(validEmailText, validPwText)
        
        let buttonActivateObservable = combineObservable
            .map { emailValid, pwValid in
                return emailValid && pwValid
            }.asDriver(onErrorJustReturn: false)
        // 로그인 api 호출 및 응답 처리
        let loginResponse = input.loginButtonEvent
            .flatMapLatest { [weak self] in
               guard let self = self else { return Observable.just(false) }
               
               return Observable.create { observer in
                   self.signIn { response in
                       observer.onNext(response)
                       observer.onCompleted()
                   }
                   return Disposables.create()
               }
               .observe(on: MainScheduler.instance)
               .share()
           }
        

        return Output(processEmailText: emailTextObservable,
                      processPwText: pwTextObservable,
                      buttonActivate: buttonActivateObservable,
                      loginResponse: loginResponse)
    }
}

extension LoginViewModel2 {
    private func signIn(completion: @escaping (Bool) -> Void) {
        let email = self.email ?? ""
        let password = self.password ?? ""
        let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? ""
        let model = LoginInput(email: email, password: password, fcmToken: deviceToken)
        
        UserService.shared.signIn(model: model) { result in
            switch result {
            case .success(let data):
                if data.success {
                    print("로그인 성공 by moya", data.data)
                    /// 사용자 정보 저장
                    self.saveUserData(data.data)
                    completion(true)
                } else {
                    completion(false)
                }

            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    /// 사용자 데이터 저장
    func saveUserData(_ data: TokenResultModel?) {
        let accessToken = data?.token.accessToken
        let refreshToken = data?.token.refreshToken
        let tempNickname = data?.tempNickname
        
        UserManager.accessToken = accessToken
        UserManager.refreshToken = refreshToken
        UserManager.isFirstLogin = false
        UserManager.email = self.email
        UserManager.password = self.password
        if let tempNickname = tempNickname {
            UserManager.tempNickname = tempNickname
        }
        
        let defaults = UserDefaults(suiteName: "group.gomin.Wishboard.Share")
        defaults?.set(accessToken, forKey: "accessToken")
        defaults?.set(refreshToken, forKey: "refreshToken")
        defaults?.synchronize()
    }
}
