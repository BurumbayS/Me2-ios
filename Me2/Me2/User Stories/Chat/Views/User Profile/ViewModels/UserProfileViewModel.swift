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
//    case block = "Заблокировать"
//    case compplain = "Пожаловаться на пользователя"
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
    var sections = [UserProfileSection]()
    var myProfileCells = [MyProfileAdditionalBlockCell]()
    var guestProfileCells = [GuestProfileAdditionalBlockCell]()
    
    var tagsExpanded = Dynamic(false)
    
    let userID: Int
    let profileType: ProfileType
    
    var chatRoom: Room!
    var userInfo: Dynamic<User>!
    var favouritePlaces: Dynamic<[Place]>!
    
    var presenterDelegate: ControllerPresenterDelegate!
    var parentVC: UserProfileViewController!
    
    var dataLoaded: Bool = false {
        didSet {
            if self.dataLoaded {
                self.sections = [.bio, .interests, .favourite_places, .additional_block]
                self.myProfileCells = [.contacts, .notifications, .settings, .feedback, .aboutApp, .logout]
                
                if let contactID = self.userInfo.value.contact?.id, contactID != 0 {
                    self.guestProfileCells = [.removeContact]
                } else {
                    self.guestProfileCells = [.addContact]
                }
                
            }
        }
    }
    
    init(userID: Int = 0, profileType: ProfileType) {
        self.userID = userID
        self.profileType = profileType
    }
    
    func getNumberOfCellsForAdditionalBlock() -> Int{
        switch profileType {
        case .myProfile:
            return myProfileCells.count
        default:
            return guestProfileCells.count
        }
    }
    
    func fetchData(completion: ResponseBlock?) {
        if let jsonString = UserDefaults().object(forKey: UserDefaultKeys.userInfo.rawValue) as? String, profileType == .myProfile {
            let userJSON = JSON(parseJSON: jsonString)
            userInfo = Dynamic(User(json: userJSON))
            favouritePlaces = Dynamic(self.userInfo.value.favouritePlaces)
            
            dataLoaded = true
            completion?(.ok, "")
        }
        
        var url = ""

        switch profileType {
        case .myProfile:
            url = myProfileURL
        case .guestProfile:
            url = Network.user + "/\(userID)/"
        }

        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):

                    let json = JSON(value)
                    self.userInfo = Dynamic(User(json: json["data"]["user"]))
                    self.favouritePlaces = Dynamic(self.userInfo.value.favouritePlaces)
                    if self.profileType == .myProfile {
                        UserDefaults().set(json["data"]["user"].rawString(), forKey: UserDefaultKeys.userInfo.rawValue)
                    }

                    self.dataLoaded = true
                    completion?(.ok, "")

                case .failure(_ ):
                    print(JSON(response.data as Any))
                    completion?(.fail, "")
                }
        }
    }
    
    func blockUser() {
        userInfo.value.contact!.blocked = true
        
        let url = Network.contact + "/\(userInfo.value.contact!.id)/block/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                case .failure(_):
                    break
                }
        }
    }
    
    func unblockUser() {
        userInfo.value.contact!.blocked = true
        
        let url = Network.contact + "/\(userInfo.value.contact!.id)/unblock/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    
                case .failure(_):
                    break
                }
        }
    }
    
    private func logout() {
        let url = Network.user + "/logout/"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Network.getAuthorizedHeaders()).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success( _):
                    
                    UserDefaults().removeObject(forKey: UserDefaultKeys.token.rawValue)
                    
                case .failure(_ ):
                    print(JSON(response.data as Any))
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
            presenterDelegate.present(controller: vc, presntationType: .push, completion: nil)
        
        case .feedback:
            
            let vc = Storyboard.feedbackViewController()
            presenterDelegate.present(controller: vc, presntationType: .push, completion: nil)
            
        case .notifications:
            
            let vc = Storyboard.notificationsViewController()
            presenterDelegate.present(controller: vc, presntationType: .push, completion: nil)
            
        case .settings:
            
            let vc = Storyboard.manageAccountViewController()
            presenterDelegate.present(controller: vc, presntationType: .push, completion: nil)
            
        case .contacts:
            
            let vc = Storyboard.myContactsViewController()
            presenterDelegate.present(controller: vc, presntationType: .push, completion: nil)
            
        case .logout:
            
            logout()
            window.rootViewController = Storyboard.signInOrUpViewController()
            
        }
    }
    
    let myProfileURL = Network.user + "/get/"
}
