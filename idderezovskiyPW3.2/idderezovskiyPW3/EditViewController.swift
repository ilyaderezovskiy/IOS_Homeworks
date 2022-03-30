//
//  EditViewController.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 29.03.2022.
//

import UIKit

class EditViewController: UIViewController, AddAndEditViewControllerLogic {
    private var containterStack: UIStackView!
    private var tableView: UITableView!
    private var timeStack: UIStackView!
    private var timePicker: UIDatePicker!
    private var alarmName: String!
    private var alarmId: Int!
    var interactor: EditViewInteractorLogic?
    
    convenience init(_ alarm: AlarmModel.ViewModel.DisplayedAlarm) {
        self.init()
        timePicker = UIDatePicker()
        timePicker.date = alarm.alarmTime
        alarmName = alarm.alarmName
        alarmId = alarm.alarmId
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Edit alarm"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .done,
            target: self,
            action: #selector(editButtonPressed)
        )
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(cancelButtonPressed)
        )
        
        self.view.backgroundColor = UIColor.init(
            red: 0.11,
            green: 0.11,
            blue: 0.12,
            alpha: 1
        )
        
        let stack = UIStackView()
        stack.distribution = .fill
        stack.axis = .vertical
        stack.alignment = .fill
        stack.backgroundColor = .clear
        view.addSubview(stack)
        stack.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        stack.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor)
        stack.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor)
        stack.pinBottom(to: view.bottomAnchor)
        
        containterStack = UIStackView()
        containterStack.distribution = .equalSpacing
        containterStack.axis = .vertical
        containterStack.alignment = .center
        setupTimeStack()
        setupTable()
        stack.addArrangedSubview(containterStack)
        
        let placeholder = UIView()
        placeholder.backgroundColor = UIColor.init(
            red: 0.11,
            green: 0.11,
            blue: 0.12,
            alpha: 1
        )
        stack.addArrangedSubview(placeholder)
        placeholder.pinWidth(to: stack.widthAnchor)
        
        interactor?.updateCurrentAlarmName(alarmName)
    }
    
    func setupTimeStack() {
        let timeStack = UIStackView()
        timeStack.axis = .horizontal
        timeStack.distribution = .equalSpacing
        timeStack.alignment = .center
        timeStack.setHeight(to: 200)
        containterStack.addArrangedSubview(timeStack)
        timeStack.pinWidth(to: containterStack.widthAnchor, 0.9)
        self.timeStack = timeStack
        
        let timeLabel = UILabel()
        timeLabel.text = "Time"
        timeLabel.textColor = .white
        timeLabel.font = timeLabel.font.withSize(20)
        timeStack.addArrangedSubview(timeLabel)
        
        if self.timePicker == nil {
            timePicker = UIDatePicker()
        }
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .inline
        timePicker.timeZone = NSTimeZone.local
        timePicker.setValue(UIColor.gray, forKey: "textColor")
        timeStack.addArrangedSubview(timePicker)
    }
    
    func setupTable() {
        let table = UITableView()
        table.register(TableCell.self, forCellReuseIdentifier: "TableCell")
        table.backgroundColor = UIColor.init(
            red: 0.17,
            green: 0.17,
            blue: 0.18,
            alpha: 1
        )
        containterStack.addArrangedSubview(table)
        table.pinLeft(to: containterStack)
        table.pinRight(to: containterStack)
        table.setHeight(to: 60)
        table.rowHeight = 60
        table.dataSource = self
        table.delegate = self
        tableView = table
    }
    
    func updateAlarmName(_ alarmName: String) {
        self.alarmName = alarmName
        tableView?.reloadData()
    }
    
    @objc
    func editButtonPressed(_ sender: Any) {
        if alarmId != nil {
            guard let timePicker = (timeStack.arrangedSubviews[1] as? UIDatePicker) else {
                interactor?.editAlarm(alarmId: alarmId, alarmTime: Date())
                return
            }
            
            let alarmTime: Date = timePicker.date
            
            interactor?.editAlarm(alarmId: alarmId, alarmTime: alarmTime)
        }
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension EditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "Alarm name"
        content.secondaryText = alarmName ?? "Alarm"
        content.textProperties.color = .white
        content.secondaryTextProperties.color = .gray
        cell.contentConfiguration = content
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .gray
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let editAlarmNameVC = EditAlarmNameViewController()
            editAlarmNameVC.interactor = interactor
            editAlarmNameVC.alarmName = alarmName
            self.navigationController?.pushViewController(editAlarmNameVC, animated: true)
        }
    }
}

extension EditViewController: UITableViewDelegate {
}

