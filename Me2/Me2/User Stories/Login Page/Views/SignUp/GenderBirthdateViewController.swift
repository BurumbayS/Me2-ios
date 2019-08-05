//
//  GenderBirthdateViewController.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 7/30/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit

class GenderBirthdateViewController: UIViewController {

    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    
    let titles = ["Мужской", "Женский"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }
    
    private func configureViews() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.locale = NSLocale.init(localeIdentifier: "ru_RU") as Locale
        birthdateTextField.inputView = datePicker
        
        pickerView.dataSource = self
        pickerView.delegate = self
        genderTextField.inputView = pickerView
    }
    
    @objc private func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.init(localeIdentifier: "ru_RU") as Locale
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        birthdateTextField.text = dateFormatter.string(from: datePicker.date)
    }
}

extension GenderBirthdateViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = titles[row]
    }
}
