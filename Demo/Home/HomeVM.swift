//
//  HomeVM.swift
//
//  Created by Shinren Pan on 2024/3/21.
//

import Combine
import UIKit

final class HomeVM {
    @Published private(set) var state = HomeModels.State.none
}

// MARK: - Public

extension HomeVM {
    func doAction(_ action: HomeModels.Action) {
        switch action {
        case .loadData:
            actionLoadData()
        }
    }
}

// MARK: - Private

private extension HomeVM {
    // MARK: Handle Action
    
    func actionLoadData() {
        if let path = Bundle.main.path(forResource: "video", ofType: "m3u8") {
            state = .dataLoaded(path: path)
        }
        else {
            state = .loadDataFailure
        }
    }
}
