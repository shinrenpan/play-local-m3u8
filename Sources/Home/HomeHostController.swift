import SwiftUI
import AVKit

@MainActor
final class HomeHostController: UIHostingController<HomeView> {
  private let viewModel: HomeViewModel

  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(rootView: HomeView(viewModel: viewModel))
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.onRoute = { [weak self] router in
      self?.handleRouter(router)
    }
  }
}

// MARK: - Router

private extension HomeHostController {
  func handleRouter(_ router: HomeViewModel.Router) {
    switch router {
    case let .openPlayer(path):
      guard let path else { return }
      let player = LocalPlayer(m3u8Path: path)
      let playerVC = AVPlayerViewController()
      playerVC.player = player
      present(playerVC, animated: true) {
        player.play()
      }
    }
  }
}
