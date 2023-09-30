//
//  HomeViewModel.swift
//  Wishboard
//
//  Created by gomin on 2023/09/29.
//

import Foundation
import RxCocoa
import RxSwift

/*
 앱 이용방법 로직
 */

final class HomeViewModel: BaseViewModel {
    
    var wishList: [WishListModel]
    var reloadCollectionView = PublishRelay<Void>()
    var performAppGuide = PublishRelay<Void>()
    
    private(set) var input: Input
    
    struct Input {
        let cartButtonTap: PublishSubject<(cartState: Int, itemId: Int)>
    }
    
    struct Output {
        var wishListSuccessResponse: Observable<[WishListModel]>
        var wishListFailCode: Observable<Int>
    }
    
    override init() {
        self.wishList = []
        self.input = Input(cartButtonTap: PublishSubject())
        
        super.init()
                
        // cartButtonTap 이벤트를 구독하여 장바구니 추가/삭제 동작 수행
        input.cartButtonTap
            .subscribe(onNext: { [weak self] (cartState, itemId) in
                self?.handleCartButtonTap(cartState: cartState, itemId: itemId)
            })
            .disposed(by: disposeBag)
        
        checkFirstLoginUser()
        setToken()
    }
    
    func transform(_ input: Input) -> Output {
        
        // 위시리스트 조회 api 호출 및 응답 처리
        let wishListResponseObservable = WishListDataManager.shared.getWishListDataManager()
        
        // 위시리스트 조회 성공 시 Reponse값
        let wishListSuccessResponse = reloadWishList(wishListResponseObservable)
        
        // 위시리스트 조회 실패 시 에러코드 반환
        let wishListFailResponse = wishListResponseObservable
            .filter { result in
                return result is Int
            }
            .map { errorCode in
                return errorCode as! Int
            }
        

        return Output(wishListSuccessResponse: wishListSuccessResponse,
                      wishListFailCode: wishListFailResponse)
    }
    
    /// 위시리스트를 새로 refresh 하는 메서드
    func refreshWishList() -> Observable<[WishListModel]> {
        let wishListResponseObservable = WishListDataManager.shared.getWishListDataManager()
        return reloadWishList(wishListResponseObservable)
    }
    
    /// 위시리스트를 reload
    private func reloadWishList(_ wishListResponseObservable: Observable<Any>) -> Observable<[WishListModel]> {
        let wishListSuccessResponse = wishListResponseObservable
            .filter { result in
                return result is [WishListModel]
            }
            .map { result in
                let response = result as? [WishListModel] ?? []
                self.wishList = response
                // 메인 스레드에서 UI 갱신
                DispatchQueue.main.async {
                   self.reloadCollectionView.accept(Void())
                }
                
                return response
            }.observe(on: MainScheduler.instance) // 메인 스레드에서 실행
        
        return wishListSuccessResponse
    }
    
    /// 장바구니 추가/삭제 동작을 처리하는 메서드
    private func handleCartButtonTap(cartState: Int, itemId: Int) {
        UIDevice.vibrate()
        if cartState == 1 {
            deleteCartItem(itemId)
        } else if cartState == 0 {
            addCartItem(itemId)
        }
    }
    
    /// 장바구니에 아이템 추가하는 메서드
    private func addCartItem(_ itemId: Int) {
        let addCartInput = AddCartInput(item_id: itemId)
        CartDataManager2.shared.addCartDataManager2(addCartInput)
            .subscribe(onNext: { [weak self] response in
                if response {
                    print("장바구니 추가")
                    self?.refreshWishListAndReload()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    /// 장바구니에서 아이템 삭제하는 메서드
    private func deleteCartItem(_ itemId: Int) {
        CartDataManager2.shared.deleteCartDataManager2(itemId)
            .subscribe(onNext: { [weak self] response in
                if response {
                    print("장바구니 삭제")
                    self?.refreshWishListAndReload()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func refreshWishListAndReload() {
        refreshWishList()
            .subscribe(onNext: { [weak self] _ in
                self?.reloadCollectionView.accept(Void())
            })
            .disposed(by: self.disposeBag)
    }
    
    /// 회원가입 후, 첫 로그인인 지 구분
    private func checkFirstLoginUser() {
        // 첫 로그인일 시 앱 이용방법 호출
        let isFirstLogin = UserManager.isFirstLogin ?? true
        if isFirstLogin {
            self.performAppGuide.accept(Void())
        }
    }
    
    /// 로그인 성공 후 앱과 Extension에 토큰 정보 저장
    private func setToken() {
        let accessToken = UserManager.accessToken
        let refreshToken = UserManager.refreshToken
        
        let defaults = UserDefaults(suiteName: "group.gomin.Wishboard.Share")
        defaults?.set(accessToken, forKey: "accessToken")
        defaults?.set(refreshToken, forKey: "refreshToken")
        defaults?.synchronize()
    }
}
