//
//  UserProfileViewModel.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 10/2/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum MyProfileAdditionalBlockCell: String {
    case contacts = "Мои контакты"
    case notifications = "Уведомления"
    case settings = "Управление аккаунтом"
    case feedback = "Обратная связь"
    case aboutApp = "О приложении"
    case logout = "Выйти"
    
    var icon: UIImage {
        switch self {
        case .contacts:
            return UIImage(named: "contacts_icon")!
        case .notifications:
            return UIImage(named: "notification_icon")!
        case .settings:
            return UIImage(named: "settings_icon")!
        case .feedback:
            return UIImage(named: "feedback_icon")!
        case .aboutApp:
            return UIImage(named: "about_app_icon")!
        case .logout:
            return UIImage(named: "logout_icon")!
        }
    }
}

enum GuestProfileAdditionalBlockCell: String {
    case addContact = "Добавить в контакты"
    case removeContact = "Удалить из контактов"
    case block = "Заблокировать"
    case compplain = "Пожаловаться на пользователя"
    
    var textColor: UIColor {
        switch self {
        case .addContact:
            return Color.blue
        default:
            return Color.red
        }
    }
}

enum ProfileType {
    case myProfile
    case guestProfile
}

enum UserProfileSection: String {
    case bio = "Био"
    case interests = "Интересы"
    case favourite_places = "Любимые места"
    case additional_block = ""
}

class UserProfileViewModel {
    var profileType = ProfileType.myProfile
    var sections = [UserProfileSection]()
    var myProfileCells = [MyProfileAdditionalBlockCell]()
    var guestProfileCells = [GuestProfileAdditionalBlockCell]()
    
    var tagsExpanded = Dynamic(false)
    
    var presenterDelegate: ControllerPresenterDelegate!
    
    var dataLoaded: Bool = false {
        didSet {
            if self.dataLoaded {
                self.sections = [.bio, .interests, .favourite_places, .additional_block]
                self.myProfileCells = [.contacts, .notifications, .settings, .feedback, .aboutApp, .logout]
                self.guestProfileCells = [.addContact, .block, .compplain]
            }
        }
    }
    
    var userInfo: Dynamic<User>!//User!
    
    func getNumberOfCellsForAdditionalBlock() -> Int{
        switch profileType {
        case .myProfile:
            return myProfileCells.count
        default:
            return guestProfileCells.count
        }
    }
    
    func fetchData(completion: ResponseBlock?) {
        Alamofire.request(userProfileURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    self.userInfo = Dynamic(User(json: json["data"]["user"]))
                    
                    self.dataLoaded = true
                    completion?(.ok, "")
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.fail, "")
                }
        }
    }
    
    func selectedCell(at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        
        switch section {
        case .additional_block:
            
            switch profileType {
            case .myProfile:
                
                selectedMyProfileCell(at: indexPath)
                
            case .guestProfile:
                
                selectedGuestProfileCell(at: indexPath)
                
            }
            
        default:
            break
        }
    }
    
    private func selectedMyProfileCell(at indexPath: IndexPath) {
        let cellType = myProfileCells[indexPath.row]
        
        switch cellType {
        case .aboutApp:
            
            let vc = Storyboard.aboutAppViewController()
            presenterDelegate.present(controller: vc, presntationType: .push)
        
        case .feedback:
            
            let vc = Storyboard.feedbackViewController()
            presenterDelegate.present(controller: vc, presntationType: .push)
            
        case .notifications:
            
            let vc = Storyboard.notificationsViewController()
            presenterDelegate.present(controller: vc, presntationType: .push)
            
        default:
            break
        }
    }
    
    private func selectedGuestProfileCell(at: IndexPath) {
        
    }
    
    let userProfileURL = Network.user + "/get/"
}
