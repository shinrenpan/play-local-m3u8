//
//  HomeVC.swift
//
//  Created by Shinren Pan on 2024/3/21.
//

import Combine
import UIKit

final class HomeVC: UIViewController {
    private let vo = HomeVO()
    private let vm = HomeVM()
    private let router = HomeRouter()
    private var binding: Set<AnyCancellable> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSelf()
        setupBinding()
        setupVO()
    }
}

// MARK: - Private

private extension HomeVC {
    // MARK: Setup Something

    func setupSelf() {
        view.backgroundColor = vo.mainView.backgroundColor
        router.vc = self
    }

    func setupBinding() {
        vm.$state.receive(on: DispatchQueue.main).sink { [weak self] state in
            if self?.viewIfLoaded?.window == nil { return }

            switch state {
            case .none:
                self?.stateNone()
            case .dataLoaded(path: let path):
                self?.stateDataLoaded(path: path)
            case .loadDataFailure:
                self?.stateLoadDataFailure()
            }
        }.store(in: &binding)
    }

    func setupVO() {
        view.addSubview(vo.mainView)
        NSLayoutConstraint.activate([
            vo.mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vo.mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            vo.mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            vo.mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        let action = UIAction { [weak self] _ in
            self?.vm.doAction(.loadData)
        }
        
        vo.playButton.addAction(action, for: .touchUpInside)
    }

    // MARK: - Handle State

    func stateNone() {}
    
    func stateDataLoaded(path: String) {
        router.toPlayerVC(path: path)
    }
    
    func stateLoadDataFailure() {
        print(#function)
    }
}
