//
//  BaseViewModel.swift
//  Wishboard
//
//  Created by gomin on 2023/06/12.
//

import Foundation
import RxSwift

protocol BaseViewModel{
    associatedtype Input
    associatedtype Output
    func transform(_ input: Input) -> Output
}
