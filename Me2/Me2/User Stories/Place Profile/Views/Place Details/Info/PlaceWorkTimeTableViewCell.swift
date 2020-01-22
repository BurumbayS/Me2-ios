//
//  PlaceWorkTimeTableViewCell.swift
//  Me2
//
//  Created by Sanzhar Burumbay on 8/28/19.
//  Copyright © 2019 AVSoft. All rights reserved.
//

import UIKit
import Cartography

class PlaceWorkTimeTableViewCell: UITableViewCell {

    let workingTimeLabel = UILabel()
    let closingTimeLabel = UILabel()
    let iconImageView = UIImageView()
    let availabilityStatusView = UIView()
    
    var workingHours: WorkingHours!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with workingHours: WorkingHours?) {
        if workingHours != nil {
            self.workingHours = workingHours
        } else { return }
        
        configureWorkTime()
        configureClosingTime()
    }
    
    private func configureWorkTime() {
        guard workingHours.weekDays.count > 0 else { return }
        
        if isAllDays() {
            workingTimeLabel.text = "Ежедневно \(workingHours.weekDays[0].start)-\(workingHours.weekDays[0].end)"
        } else
        if isWeekends() {
            let weekend = workingHours.weekDays.first(where: { $0.isWeekend })
            workingTimeLabel.text = "Выходные \(weekend!.start)-\(weekend!.end)"
        } else
        if isWorkdays() {
            let workday = workingHours.weekDays.first(where: { !$0.isWeekend })
            workingTimeLabel.text = "Будни \(workday!.start)-\(workday!.end)"
        } else {
            var workTime = ""
            for day in workingHours.weekDays {
                workTime += "\(day.name.localShortTitle) \(day.start)-\(day.end) • "
            }
            workingTimeLabel.text = workTime
        }
    }
    
    private func configureClosingTime() {
        guard workingHours.weekDays.count > 0 else { return }
        
        let today = Date().dayOfTheWeek()
        let day = workingHours.weekDays.filter { $0.title == today }[0]
        let time = Date().currentTime()
        
        if time > day.start && time < day.end {
            closingTimeLabel.text = "Открыто до \(day.end)"
            availabilityStatusView.backgroundColor = Color.green
        }
        if time < day.start {
            closingTimeLabel.text = "Закрыто до \(day.start)"
            availabilityStatusView.backgroundColor = Color.red
        }
        if time > day.end {
            closingTimeLabel.text = "Закрыто до завтра"
            availabilityStatusView.backgroundColor = Color.red
        }
        if time > day.end && day.end == "00:00" {
            closingTimeLabel.text = "Открыто до \(day.end)"
            availabilityStatusView.backgroundColor = Color.green
        }
    }
    
    private func isAllDays() -> Bool {
        var isEqual = true
        
        for weekday1 in workingHours.weekDays {
            for weekday2 in workingHours.weekDays {
                if !weekday1.isEgual(to: weekday2) && weekday1.works && weekday2.works {
                    isEqual = false
                }
            }
        }
        
        return isEqual
    }
    
    private func isWeekends() -> Bool {
        var isWeekends = true
        
        let weekends = workingHours.weekDays.filter({ $0.isWeekend })
        let workDays = workingHours.weekDays.filter({ !$0.isWeekend })
        
        for day in workDays {
            if day.works {
                isWeekends = false
            }
        }
        
        if !(weekends[0].works && weekends[1].works && weekends[0].isEgual(to: weekends[1])) { isWeekends = false }
        
        return isWeekends
    }
    
    private func isWorkdays() -> Bool {
        var isWorkdays = true
        
        let weekends = workingHours.weekDays.filter({ $0.isWeekend })
        let workDays = workingHours.weekDays.filter({ !$0.isWeekend })
        
        for day in weekends {
            if day.works {
                isWorkdays = false
            }
        }
        
        for weekday1 in workDays {
            for weekday2 in workDays {
                if !weekday1.isEgual(to: weekday2) && weekday1.works && weekday2.works {
                    isWorkdays = false
                }
            }
        }
        
        return isWorkdays
    }
    
    private func setUpViews() {
        iconImageView.image = UIImage(named: "time")
        self.contentView.addSubview(iconImageView)
        constrain(iconImageView, self.contentView) { icon, view in
            icon.width == 20
            icon.height == 20
            icon.left == view.left + 20
        }
        
        let view = UIView()
        
        workingTimeLabel.textColor = .gray
        workingTimeLabel.numberOfLines = 0
        workingTimeLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        view.addSubview(workingTimeLabel)
        constrain(workingTimeLabel, view) { label, view in
            label.top == view.top
            label.left == view.left
            label.right == view.right
        }
        
        closingTimeLabel.textColor = .gray
        closingTimeLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        view.addSubview(closingTimeLabel)
        constrain(closingTimeLabel, workingTimeLabel, view) { closingTimeLabel, workingTimeLabel, view in
            closingTimeLabel.top == workingTimeLabel.bottom
            closingTimeLabel.bottom == view.bottom
            closingTimeLabel.leading == workingTimeLabel.leading
        }
        
        availabilityStatusView.layer.cornerRadius = 3
        availabilityStatusView.backgroundColor = .white
        view.addSubview(availabilityStatusView)
        constrain(availabilityStatusView, closingTimeLabel, view) { status, label, view in
            status.left == label.right + 5
            status.centerY == label.centerY
            status.height == 6
            status.width == 6
        }
        
        self.contentView.addSubview(view)
        constrain(view, iconImageView, self.contentView) { view, icon, contentView in
            view.left == icon.right + 15
            view.right == contentView.right - 22
            view.top == contentView.top + 10
            view.bottom == contentView.bottom - 15
            view.centerY == icon.centerY
        }
    }
}
