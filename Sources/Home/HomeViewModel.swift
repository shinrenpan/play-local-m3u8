import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
  enum Action: Sendable {
    case view(ViewAction)
  }

  var state: State = .init()

  @ObservationIgnored
  var onRoute: (@MainActor (Router) -> Void)?

  func doAction(_ action: Action) async {
    switch action {
    case let .view(action):
      await handleViewAction(action)
    }
  }
}

// MARK: - View Action

extension HomeViewModel {
  enum ViewAction: Sendable {
    case playButtonDidTap
  }

  private func handleViewAction(_ action: ViewAction) async {
    switch action {
    case .playButtonDidTap:
      let path = Bundle.main.path(forResource: "video", ofType: "m3u8")
      onRoute?(.openPlayer(path: path))
    }
  }
}

// MARK: - Router

extension HomeViewModel {
  enum Router: Sendable {
    case openPlayer(path: String?)
  }
}
