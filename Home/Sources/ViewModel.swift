//
//  ViewModel.swift
//  Home
//
//  Created by Joe Pan on 2025/3/5.
//

import Combine
import UIKit

final class ViewModel {
    @Published private(set) var state = State.none
}

// MARK: - Public

extension ViewModel {
    func doAction(_ action: Action) {
        switch action {
        case .loadData:
            actionLoadData()
        }
    }
}

// MARK: - Private

private extension ViewModel {
    func actionLoadData() {
        if let path = Bundle.main.path(forResource: "video", ofType: "m3u8") {
            state = .dataLoaded(path: path)
        }
        else {
            state = .loadDataFailure
        }
    }
}
