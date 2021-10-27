//
//  StackViewController.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 23.10.2021.
//

import UIKit

class StackViewController: UIViewController {
    
    private var data = [Alarm(time: "01:01"), Alarm(time: "05:01"), Alarm(time: "02:01"), Alarm(time: "14:11"), Alarm(time: "02:01"), Alarm(time: "02:25"), Alarm(time: "08:01"), Alarm(time: "08:05"), Alarm(time: "02:21"), Alarm(time: "09:12"), Alarm(time: "03:10"), Alarm(time: "02:01"), Alarm(time: "01:01"), Alarm(time: "08:05"), Alarm(time: "08:02"),Alarm(time: "08:03"), Alarm(time: "08:04"), Alarm(time: "08:00"), Alarm(time: "08:01"), Alarm(time: "05:01"), Alarm(time: "02:01"), Alarm(time: "01:01"), Alarm(time: "05:01"), Alarm(time: "08:10"), Alarm(time: "09:00"), Alarm(time: "09:10"), Alarm(time: "09:15"), Alarm(time: "09:20"), Alarm(time: "15:01"), Alarm(time: "12:01"), Alarm(time: "21:01"), Alarm(time: "15:01"), Alarm(time: "22:01")]
    
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    
        override func viewDidLoad()
        {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.white
            self.tabBarController?.navigationItem.title = "Alarms"
            self.navigationController?.navigationBar.prefersLargeTitles = true

            data.sort(by: {$0.time < $1.time})
            
            self.view.addSubview(self.tableView)
            self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
            self.tableView.dataSource = self
            self.updateLayout(with: self.view.frame.size)
        }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to: size, with: coordinator)
       coordinator.animate(alongsideTransition: { (contex) in
          self.updateLayout(with: size)
       }, completion: nil)
    }
    
    private func updateLayout(with size: CGSize) {
       self.tableView.frame = CGRect.init(origin: .zero, size: size)
    }
}

extension StackViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       switch tableView {
       case self.tableView:
          return self.data.count
        default:
          return 0
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row

        cell.textLabel?.text = self.data[indexPath.row].time
        cell.accessoryView = switchView
        return cell
    }
}


class TableViewCell: UITableViewCell {

}
