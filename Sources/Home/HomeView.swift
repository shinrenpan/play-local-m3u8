import SwiftUI

struct HomeView: View {
  let viewModel: HomeViewModel

  var body: some View {
    Button("Play") {
      Task { await viewModel.doAction(.view(.playButtonDidTap)) }
    }
  }
}
