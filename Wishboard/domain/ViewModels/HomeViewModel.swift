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
 위시리스트 조회
 카트 추가/삭제 로직
 이벤트뷰 로직
 앱 이용방법 로직
 아이템 클릭 시 상세화면으로 이동 (VC)
 refresh 로직
 */

final class HomeViewModel: BaseViewModel {
    
    var wishList: [WishListModel]
    var reloadCollectionView = PublishRelay<Void>()
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
        CartDataManager().addCartDataManager2(addCartInput)
        
        refreshWishList()
            .subscribe(onNext: { [weak self] _ in
                print("장바구니 추가")
                self?.reloadCollectionView.accept(Void())
            })
            .disposed(by: self.disposeBag)
    }
    
    /// 장바구니에서 아이템 삭제하는 메서드
    private func deleteCartItem(_ itemId: Int) {
        CartDataManager().deleteCartDataManager(itemId, self)
        
        refreshWishList()
            .subscribe(onNext: { [weak self] _ in
                print("장바구니 삭제")
                self?.reloadCollectionView.accept(Void())
            })
            .disposed(by: self.disposeBag)
    }
    
    
}
