//
//  HomeViewModel.swift
//  Demo
//
//  Created by Joe Pan on 2025/12/15.
//

import Foundation
import Observation

@MainActor
final class HomeViewModel {
  enum Action: Equatable, Sendable {
    case view(ViewAction)
    case router(Router)
  }

  var onAction: (@MainActor (Action) -> Void)?

  func doAction(_ action: Action) async {
    switch action {
    case let .view(action):
      await handleViewAction(action)

    case let .router(router):
      await handleRouter(router)
    }
  }
}

// MARK: - View Action

extension HomeViewModel {
  enum ViewAction: Equatable, Sendable {
    case playButtonDidTap
  }

  private func handleViewAction(_ action: ViewAction) async {
    switch action {
    case .playButtonDidTap:
      let path = Bundle.main.path(forResource: "video", ofType: "m3u8")
      await doAction(.router(.openPlayer(path: path)))
    }
  }
}

// MARK: - Router

extension HomeViewModel {
  enum Router: Equatable, Sendable {
    case openPlayer(path: String?)
  }

  private func handleRouter(_ router: Router) async {
    onAction?(.router(router))
  }
}
