//
//  BaseViewModel.swift
//  Wishboard
//
//  Created by gomin on 2023/09/05.
//

import Foundation
import RxCocoa
import RxSwift

protocol ViewModelable {
    associatedtype Input
    associatedtype Output
    func transform(_ : Input) -> Output
}

class BaseViewModel: ViewModelable {
    var disposeBag = DisposeBag()
    
    struct Input { }
    
    struct Output { }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
