//
//  Router.swift
//  Home
//
//  Created by Joe Pan on 2025/3/5.
//

import UIKit
import AVKit

@MainActor final class Router {
    weak var vc: ViewController?
}

// MARK: - Internal

internal extension Router {
    func toPlayerVC(path: String) {
        let player = LocalPlayer(m3u8Path: path)
        let to = AVPlayerViewController()
        to.player = player
        
        vc?.present(to, animated: true) {
            player.play()
        }
    }
}
