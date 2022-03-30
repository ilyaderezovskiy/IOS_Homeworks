//
//  TableViewController.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 29.03.2022.
//

import UIKit

class TableViewController: ViewController {
    private var table: UITableView?
    private var alarmViews: [AlarmView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Table"
        
        var tabBarItem = UITabBarItem()
        tabBarItem = UITabBarItem(
            title: "Table",
            image: UIImage(named: "table"),
            selectedImage: UIImage(named: "table")
        )
        self.tabBarItem = tabBarItem
        self.view.backgroundColor = .green
        
        setupTableView()
    }
    
    func setupTableView() {
        let table = UITableView(frame: .zero, style: .plain)
        view.addSubview(table)
        table.backgroundColor = .white
        table.dataSource = self
        table.bounces = true
        table.alwaysBounceVertical = true
        table.register(TableCell.self, forCellReuseIdentifier: "TableCell")
        table.pinTop(to: self.view.topAnchor)
        table.pinBottom(to: self.view.bottomAnchor)
        table.pinWidth(to: self.view.widthAnchor)
        table.rowHeight = CGFloat(Double(AlarmView.viewHeight))
        table.tableFooterView = UIView()
        self.table = table
    }
    
    func updateData(_ data: AlarmModel.ViewModel) {
        alarmViews.removeAll()
        
        for i in 0 ..< data.displayedAlarms.count {
            let alarmId = data.displayedAlarms[i].alarmId
            let alarmTime = data.displayedAlarms[i].alarmTime
            let isOn = data.displayedAlarms[i].isOn
            let alarmName = data.displayedAlarms[i].alarmName
            
            let alarmView = AlarmView(
                updateAction: self.updateAlarm,
                edit: self.editAlarm,
                alarmId: alarmId,
                alarmName: alarmName,
                alarmTime: alarmTime,
                isOn: isOn
            )

            alarmViews.append(alarmView)
        }

        table?.reloadData()
    }
    
    func updateAndPresentAlarm(_ alarmViewModel: AlarmModel.ViewModel.DisplayedAlarm) {
        let alarmId = alarmViewModel.alarmId
        let alarmTime = alarmViewModel.alarmTime
        let isOn = alarmViewModel.isOn
        let alarmName = alarmViewModel.alarmName
        
        for i in 0 ..< alarmViews.count {
            if alarmViews[i].getAlarmId() == alarmViewModel.alarmId {
                alarmViews[i] = AlarmView(
                    updateAction: self.updateAlarm,
                    edit: self.editAlarm,
                    alarmId: alarmId,
                    alarmName: alarmName,
                    alarmTime: alarmTime,
                    isOn: isOn
                )
            }
        }
        
        table?.reloadData()
    }
}

extension TableViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmViews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table?.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        
        if let cell = cell {
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
        }
        
        cell?.contentView.addSubview(alarmViews[indexPath.item])
        alarmViews[indexPath.item].pin(to: cell?.contentView ?? alarmViews[indexPath.item])
        
        return cell ?? UITableViewCell()
    }
}

extension TableViewController : UITableViewDelegate {
}

