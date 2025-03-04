//
//  ViewController.swift
//  Home
//
//  Created by Joe Pan on 2025/3/5.
//

import Combine
import UIKit

public final class ViewController: UIViewController {
    private let vo = ViewOutlet()
    private let vm = ViewModel()
    private let router = Router()
    private var binding: Set<AnyCancellable> = .init()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupSelf()
        setupBinding()
        setupVO()
    }
}

// MARK: - Private

private extension ViewController {
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

    func stateNone() {}
    
    func stateDataLoaded(path: String) {
        router.toPlayerVC(path: path)
    }
    
    func stateLoadDataFailure() {
        print(#function)
    }
}
