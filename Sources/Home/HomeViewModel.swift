import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
  enum Action: Sendable {
    case view(ViewAction)
    case router(Router)
  }

  var state: State = .init()

  @ObservationIgnored
  var onAction: (@MainActor (Action) -> Void)?

  func doAction(_ action: Action) async {
    switch action {
    case let .view(action):
      await handleViewAction(action)

    case let .router(router):
      handleRouter(router)
    }
  }
}

// MARK: - ViewAction

extension HomeViewModel {
  enum ViewAction: Sendable {
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
  enum Router: Sendable {
    case openPlayer(path: String?)
  }

  private func handleRouter(_ router: Router) {
    onAction?(.router(router))
  }
}
