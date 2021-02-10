//
//  BaseViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 2/25/20.
//  Copyright © 2020 AVSoft. All rights reserved.
//

import UIKit
import SVProgressHUD

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

        self.viewModel?.showLoading.bind { text in
            if let text = text, !text.isEmpty {
                SVProgressHUD.show(withStatus: text)
            } else {
                SVProgressHUD.dismiss()
            }
        }

        self.viewModel.showHub.bind { status in
            switch status {
            case .fail(let text):
                SVProgressHUD.showError(withStatus: text)
            case .success(let text):
                SVProgressHUD.showSuccess(withStatus: text)
            }
        }

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
