//
//  AlarmView.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 24.10.2021.
//

import UIKit

class AlarmView: UIView {
    private var alarmId: Int!
    private var alarmToggle: UISwitch!
    private var alarmTimeLabel: UILabel!
    private var alarmNameLabel: UILabel!
    private var updateAction: ((Int) -> Void)?
    private var editAction: ((Int) -> Void)?
    private var tapGestureRecognizer: UITapGestureRecognizer!
    public static let viewHeight = 100
    
    convenience init(updateAction: @escaping ((Int) -> Void), edit: @escaping ((Int) -> Void), alarmId: Int, alarmName: String, alarmTime: Date, isOn: Bool) {
        self.init()
        self.alarmId = alarmId
        self.updateAction = updateAction
        self.editAction = edit
        self.backgroundColor = .white
        
        tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(alarmViewTapped)
        )
        self.addGestureRecognizer(tapGestureRecognizer)
        
        setupAlarmToggle(isOn)
        setupAlarmTimeLabel(alarmTime)
        setupAlarmNameLabel(alarmName)
        setupBorder()
    }
    
    func setupAlarmToggle(_ isOn: Bool) {
        alarmToggle = UISwitch()
        self.addSubview(alarmToggle)
        alarmToggle.isOn = isOn
        alarmToggle.pinLeft(to: self.leadingAnchor, 10)
        alarmToggle.pinCenter(to: self.centerYAnchor)
        alarmToggle.addTarget(self, action: #selector(alarmToggleSwitched), for: .valueChanged)
    }
    
    func setupAlarmTimeLabel(_ alarmTime: Date) {
        alarmTimeLabel = UILabel()
        self.addSubview(alarmTimeLabel)
        alarmTimeLabel.pinRight(to: self.trailingAnchor, 10)
        alarmTimeLabel.pinCenter(to: self.centerYAnchor, -10)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        alarmTimeLabel.text = dateFormatter.string(from: alarmTime)
        alarmTimeLabel.textColor = .gray
        alarmTimeLabel.font = alarmTimeLabel.font.withSize(40)
    }
    
    func setupAlarmNameLabel(_ alarmName: String) {
        alarmNameLabel = UILabel()
        self.addSubview(alarmNameLabel)
        alarmNameLabel.pinRight(to: self.trailingAnchor, 10)
        alarmNameLabel.pinTop(to: alarmTimeLabel.bottomAnchor, 5)
        alarmNameLabel.text = alarmName
        alarmNameLabel.textColor = .gray
    }
    
    func setupBorder() {
        let borderView = UIView()
        borderView.setHeight(to: 0.5)
        self.addSubview(borderView)
        borderView.pinBottom(to: bottomAnchor)
        borderView.pinWidth(to: widthAnchor)
        borderView.backgroundColor = .darkGray
        borderView.pinCenter(to: centerXAnchor)
    }
    
    @objc
    func alarmToggleSwitched(_ sender: Any) {
        updateAction?(alarmId)
    }
    
    @objc
    func alarmViewTapped(_ sender: Any) {
        editAction?(alarmId)
    }
    
    func getAlarmId() -> Int {
        return alarmId
    }
}
