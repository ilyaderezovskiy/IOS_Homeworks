//
//  CreateNewAlarmViewControler.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 30.03.2022.
//

import UIKit

protocol AddAndEditAlarmInteractorLogic {
    func updateCurrentAlarmName(_ alarmName: String)
}

protocol AddAndEditViewControllerLogic {
    func updateAlarmName(_ alarmName: String)
}

class AddAlarmViewController: UIViewController, AddAndEditViewControllerLogic {
    private var containterStack: UIStackView!
    private var tableView: UITableView!
    private var timeStack: UIStackView!
    private var displayedAlarmName: String = "Alarm"
    var interactor: AddAlarmViewInteractorLogic?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add alarm"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(addButtonPressed)
        )
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(cancelButtonPressed)
        )
        
        self.view.backgroundColor = .white
        
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
        placeholder.backgroundColor = .white
        stack.addArrangedSubview(placeholder)
        placeholder.pinWidth(to: stack.widthAnchor)
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
        timeLabel.textColor = .black
        timeLabel.font = timeLabel.font.withSize(20)
        timeStack.addArrangedSubview(timeLabel)
        
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .inline
        timePicker.timeZone = NSTimeZone.local
        timePicker.setValue(UIColor.white, forKey: "textColor")
        timeStack.addArrangedSubview(timePicker)
    }
    
    func setupTable() {
        let table = UITableView()
        table.register(TableCell.self, forCellReuseIdentifier: "TableCell")
        table.backgroundColor = .white
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
        displayedAlarmName = alarmName
        tableView.reloadData()
    }
    
    @objc
    func addButtonPressed(_ sender: Any) {
        guard let timePicker = (timeStack.arrangedSubviews[1] as? UIDatePicker) else {
            interactor?.addAlarm(alarmTime: Date())
            return
        }
        
        let alarmTime: Date = timePicker.date
        
        interactor?.addAlarm(alarmTime: alarmTime)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension AddAlarmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = "Alarm name"
        content.secondaryText = displayedAlarmName
        content.textProperties.color = .black
        content.secondaryTextProperties.color = .black
        cell.contentConfiguration = content
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .default
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let addAlarmNameVC = EditAlarmNameViewController()
            addAlarmNameVC.interactor = interactor
            addAlarmNameVC.alarmName = displayedAlarmName
            self.navigationController?.pushViewController(addAlarmNameVC, animated: true)
        }
    }
}

extension AddAlarmViewController: UITableViewDelegate {
}
