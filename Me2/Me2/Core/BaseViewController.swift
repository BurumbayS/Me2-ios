//
//  BaseViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 2/25/20.
//  Copyright © 2020 AVSoft. All rights reserved.
//

import UIKit

class BaseViewControllerT<T: BaseViewModel>: BaseViewController {

    var viewModel: T!

    override func viewDidLoad() {
        self.viewModel = self.initViewModel()
        super.viewDidLoad()
        self.setupView()
        self.setupViewSubscription()
        self.viewModel?.viewDidLoad()
    }

    func setupViewSubscription() {
        self.viewModel?.error.bind { [weak self] text in
            guard let text = text, !text.isEmpty else {
                return
            }
            self?.showInfoAlert(title: "Ошибка", message: text, onAccept: nil)
        }

        self.viewModel?.showLoading.bind { [weak self] text in
            if let text = text, !text.isEmpty {
                self?.startLoader(withText: text)
            } else {
                self?.stopLoader()
            }
        }

//        self.viewModel.stopWithStatus.bind {[weak self] status in
//            switch status {
//            case .fail(let text):
//                self?.stopLoader(withStatus: .fail, andText: text, completion: nil)
//            case .success(let text):
//                self?.stopLoader(withStatus: .success, andText: text, completion: nil)
//            }
//        }

        self.viewModel.settingError.bind {[weak self] tuple in
            guard let `self` = self, let tuple = tuple else { return }
            let alert = UIAlertController.init(title: tuple.title, message: tuple.message, preferredStyle: .alert)
            alert.addAction(.init(title: "Настройки", style: .default) { _ in
                guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settingURL)
            })
            alert.addAction(.init(title: "Закрыть", style: .destructive))
            self.present(alert, animated: true)
        }
    }

    func initViewModel() -> T {
        fatalError()
    }

    func setupView() {
    }
}

class BaseViewController: UIViewController {
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {

        if viewControllerToPresent.modalPresentationStyle != .custom {
            viewControllerToPresent.modalPresentationStyle = .fullScreen
        }

        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
