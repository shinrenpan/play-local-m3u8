//
//  HomeRouter.swift
//
//  Created by Shinren Pan on 2024/3/21.
//

import UIKit
import AVKit

final class HomeRouter {
    weak var vc: HomeVC?
}

// MARK: - Public

extension HomeRouter {
    func toPlayerVC(path: String) {
        let player = LocalPlayer(m3u8Path: path)
        let to = AVPlayerViewController()
        to.player = player
        
        vc?.present(to, animated: true) {
            player.play()
        }
    }
}
