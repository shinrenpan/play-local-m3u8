//
//  HomeViewController.swift
//  Demo
//
//  Created by Joe Pan on 2025/12/15.
//

import SwiftUI
import AVKit

final class HomeViewController: UIHostingController<HomeView> {
  private let viewModel: HomeViewModel
  
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    let view = HomeView(viewModel: viewModel)
    super.init(rootView: view)
  }
  
  @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    listenAction()
  }
}

// MARK: -

private extension HomeViewController {
  func listenAction() {
    viewModel.onAction = { [weak self] action in
      Task { @MainActor in
        switch action {
        case .view:
          break

        case let .router(router):
          self?.handleRouter(router)
        }
      }
    }
  }

  func handleRouter(_ router: HomeViewModel.Router) {
    switch router {
    case let .openPlayer(path):
      if let path {
        let player = LocalPlayer(m3u8Path: path)
        let to = AVPlayerViewController()
        to.player = player
        present(to, animated: true) {
          player.play()
        }
      }
    }
  }
}
