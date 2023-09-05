//
//  BaseViewModel.swift
//  Wishboard
//
//  Created by gomin on 2023/09/05.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    func transform(_ : Input) -> Output
}
