//
// Created by A on 08.02.2021.
// Copyright (c) 2021 AVSoft. All rights reserved.
//

import Foundation

class BaseViewModel {
    var error: Dynamic<String?> = .init(nil)
    var showLoading: Dynamic<String?> = .init(nil)
    var settingError: Dynamic<(title: String, message: String)?> = Dynamic.init(nil)
    var showHub: Dynamic<Status<String>> = .init(.success(""))

    func viewDidLoad() {
    }
}
