//
//  ViewOutlet.swift
//  Home
//
//  Created by Joe Pan on 2025/3/5.
//

import UIKit

@MainActor final class ViewOutlet {
    let mainView = UIView(frame: .zero)
    let playButton = UIButton(type: .system)
    
    init() {
        addViews()
    }
}

// MARK: - Private

private extension ViewOutlet {
    func addViews() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        playButton.setTitle("Play", for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
        ])
    }
}
