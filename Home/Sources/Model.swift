//
//  Model.swift
//  Home
//
//  Created by Joe Pan on 2025/3/5.
//

import Foundation

enum Action {
    case loadData
}

enum State {
    case none
    case dataLoaded(path: String)
    case loadDataFailure
}
