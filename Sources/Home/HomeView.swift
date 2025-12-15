//
//  HomeView.swift
//  Demo
//
//  Created by Joe Pan on 2025/12/15.
//

import SwiftUI

struct HomeView: View {
  let viewModel: HomeViewModel

  var body: some View {
    Button("Play") {
      Task { await viewModel.doAction(.view(.playButtonDidTap)) }
    }
  }
}
