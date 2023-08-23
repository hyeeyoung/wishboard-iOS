//
//  UseCase.swift
//  Wishboard
//
//  Created by gomin on 2023/08/20.
//

import Foundation

/// 유즈케이스
enum ObserverUseCase {
    // User
    case signOut
    case profileModified
    case passwordModified
    
    // Item Parsing
    case itemLinkExit
    case itemParsingFail
    case itemParsingSuccess
}
