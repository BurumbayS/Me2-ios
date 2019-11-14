//
//  AccessCodeViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 9/4/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class AccessCodeViewController: UIViewController {
    
    @IBOutlet weak var accessCodeStackView: UIStackView!
    @IBOutlet weak var numberPadCollectionView: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var viewModel = AccessCodeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureViews()
        configureCollectionView()
        bindViewModel()
    }
    
    private func configureNavBar() {
        navBar.tintColor = .black
        navBar.shouldRemoveShadow(true)
        
        navItem.title = ""
        
        switch viewModel.accesCodeType {
        case .check:
            navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "x_icon"), style: .plain, target: self, action: #selector(dismissVC))
        case .confirm, .create:
            setUpBackBarButton(for: navItem)
        default:
            break
        }
    }

    private func configureViews() {
        titleLabel.text = viewModel.accesCodeType.title
        
        for item in accessCodeStackView.arrangedSubviews {
            item.backgroundColor = .lightGray
        }
        
        errorLabel.isHidden = true
    }
    
    private func configureCollectionView() {
        numberPadCollectionView.delegate = self
        numberPadCollectionView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.accessCode.bind { [weak self] (code) in
            let index = code.count
            
            if let views = self?.accessCodeStackView.arrangedSubviews {
                for (i, item) in views.enumerated() {
                    item.backgroundColor = (i < index) ? Color.blue : .lightGray
                }
            }
        }
    }
    
    private func checkAccesCode() {
        guard viewModel.accessCode.value.count == 4 else { return }
        
        switch viewModel.accesCodeType {
        case .enter:
            
            if viewModel.accessCode.value == UserDefaults().object(forKey: UserDefaultKeys.accessCode.rawValue) as? String {
                window.rootViewController = Storyboard.mainTabsViewController()
            } else {
                errorLabel.text = "Неверный код доступа"
                errorLabel.isHidden = false
            }
            
        case .create:
            
            viewModel.accesCodeType = .confirm
            titleLabel.text = viewModel.accesCodeType.title
            viewModel.createdAccessCode = viewModel.accessCode.value
            
        case .confirm:
            
            if viewModel.accessCode.value == viewModel.createdAccessCode {
                UserDefaults().set(viewModel.accessCode.value, forKey: UserDefaultKeys.accessCode.rawValue)
                self.navigationController?.popViewController(animated: true)
            } else {
                errorLabel.text = "Код доступа не совпадает"
                errorLabel.isHidden = false
            }
            
        case .check:
            
            if viewModel.accessCode.value == UserDefaults().object(forKey: UserDefaultKeys.accessCode.rawValue) as? String {
                viewModel.correctAccessCodeHandler?()
                dismiss(animated: true, completion: nil)
            } else {
                errorLabel.text = "Неверный код доступа"
                errorLabel.isHidden = false
            }
        }
        
        viewModel.accessCode.value = ""
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

}

extension AccessCodeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        let height = collectionView.frame.height / 4
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberPadCell", for: indexPath)
        
        switch indexPath.row + 1 {
        case 10,12:
            let image = UIImageView()
            image.image = (indexPath.row + 1 == 10) ? UIImage(named: "faceid_icon") : UIImage(named: "delete_button")
            image.isHidden = (indexPath.row + 1 == 10 && viewModel.accesCodeType != .enter)
            image.contentMode = .scaleAspectFit
            cell.contentView.addSubview(image)
            constrain(image, cell.contentView) { image, cell in
                image.centerY == cell.centerY
                image.centerX == cell.centerX
                image.height == 36
                image.width == 36
            }
        default:
            let label = UILabel()
            label.textColor = .black
            label.text = (indexPath.row + 1 == 11) ? "0" : "\(indexPath.row + 1)"
            label.font = UIFont(name: "Roboto-Medium", size: 34)
            
            cell.contentView.addSubview(label)
            constrain(label, cell.contentView) { label, cell in
                label.centerY == cell.centerY
                label.centerX == cell.centerX
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row + 1 {
        case 10:
            break
        case 12:
            if viewModel.accessCode.value.count > 0 {
                viewModel.accessCode.value.removeLast()
            }
        default:
            if viewModel.accessCode.value.count < 4 {
                viewModel.accessCode.value += (indexPath.row + 1 == 11) ? "0" : "\(indexPath.row + 1)"
            }
            
            checkAccesCode()
        }
    }
}
