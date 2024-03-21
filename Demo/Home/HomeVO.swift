//
//  HomeVO.swift
//
//  Created by Shinren Pan on 2024/3/21.
//

import UIKit

final class HomeVO {
    let mainView = UIView(frame: .zero)
    let playButton = UIButton(type: .system)
    
    init() {
        addViews()
    }
}

// MARK: - Private

private extension HomeVO {
    // MARK: - Add Something
    
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
