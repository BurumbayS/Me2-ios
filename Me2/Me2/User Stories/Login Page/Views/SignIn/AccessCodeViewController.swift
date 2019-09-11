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
    
    let viewModel = AccessCodeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureCollectionView()
        bindViewModel()
    }

    private func configureViews() {
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
        if viewModel.accessCode.value.count == 4 {
            errorLabel.isHidden = false
            viewModel.accessCode.value = ""
        }
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
