//
//  HomeModels.swift
//
//  Created by Shinren Pan on 2024/3/21.
//

import UIKit

enum HomeModels {}

// MARK: - Action

extension HomeModels {
    enum Action {
        case loadData
    }
}

// MARK: - State

extension HomeModels {
    enum State {
        case none
        case dataLoaded(path: String)
        case loadDataFailure
    }
}
