import SwiftUI
import AVKit

@MainActor
final class HomeHostController: UIHostingController<HomeView> {

  // MARK: - ViewModel
  let viewModel: HomeViewModel

  // MARK: - Init
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    let view = HomeView(viewModel: viewModel)
    super.init(rootView: view)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Lifecycle

extension HomeHostController {
  override func viewDidLoad() {
    super.viewDidLoad()
    listenSelfAction()
  }
}

// MARK: - Router

private extension HomeHostController {
  func listenSelfAction() {
    viewModel.onAction = { [weak self] action in
      switch action {
      case .view:
        break

      case let .router(router):
        self?.handleSelfRouter(router)
      }
    }
  }

  func handleSelfRouter(_ router: HomeViewModel.Router) {
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
