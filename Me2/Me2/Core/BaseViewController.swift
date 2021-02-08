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
        
        self.viewModel.stopWithStatus.bind {[weak self] status in
            switch status {
            case .fail(let text):
                self?.stopLoader(withStatus: .fail, andText: text, completion: nil)
            case .success(let text):
                self?.stopLoader(withStatus: .success, andText: text, completion: nil)
            }
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
