//
//  TableViewController.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 23.10.2021.
//

import UIKit

class TableViewController: UIViewController {

    private var data = [Alarm(time: "01:01"), Alarm(time: "05:01"), Alarm(time: "02:01"), Alarm(time: "14:11"), Alarm(time: "02:01"), Alarm(time: "02:25"), Alarm(time: "08:01"), Alarm(time: "08:05"), Alarm(time: "02:21"), Alarm(time: "09:12"), Alarm(time: "03:10"), Alarm(time: "02:01"), Alarm(time: "01:01"), Alarm(time: "08:05"), Alarm(time: "08:02"),Alarm(time: "08:03"), Alarm(time: "08:04"), Alarm(time: "08:00"), Alarm(time: "08:01"), Alarm(time: "05:01"), Alarm(time: "02:01"), Alarm(time: "01:01"), Alarm(time: "05:01"), Alarm(time: "08:10"), Alarm(time: "09:00"), Alarm(time: "09:10"), Alarm(time: "09:15"), Alarm(time: "09:20"), Alarm(time: "15:01"), Alarm(time: "12:01"), Alarm(time: "21:01"), Alarm(time: "15:01"), Alarm(time: "22:01")]
    
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    
        override func viewDidLoad()
        {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.white
            self.tabBarController?.navigationItem.title = "Alarms"
            self.navigationController?.navigationBar.prefersLargeTitles = true
            
            data.sort(by: {$0.time < $1.time})
            
            self.tableView.register(EyeCell.self, forCellReuseIdentifier: "eyeCell")
            self.view.addSubview(self.tableView)
            self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
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

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "eyeCell", for: indexPath) as? EyeCell
            
        cell?.prepareForReuse()
        cell?.setupEye()
        return cell ?? UITableViewCell()
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        300
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

final class EyeCell: UITableViewCell {
func setupEye() {
    let image = UIImageView()
    prepareForReuse()
    addSubview(image)
    image.pinLeft(to: self, Double.random(in: 0...400))
    image.pinTop(to: self, Double.random(in: -20...40))
    image.image = UIImage(named: "eye")
    image.setHeight(height: 20)
    image.setWidth(width: 30)
    prepareForReuse()
    }
    override func prepareForReuse() {
        for subview in subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
    }
    }
}

extension UIView {
    func setHeight(height : CGFloat) {
            var frame:CGRect = self.frame
            frame.size.height = height
            self.frame = frame
        }
    func setWidth(width:CGFloat) {
            var frame:CGRect = self.frame
            frame.size.width = width
            self.frame = frame
        }
    @discardableResult
    func pinLeft(to superView: UIView, _ const: Double = 0) -> NSLayoutConstraint {
        superView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = superView.leadingAnchor.constraint(
            equalTo: superView.leadingAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func pinTop(to superView: UIView, _ const: Double = 0) -> NSLayoutConstraint {
        superView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = superView.topAnchor.constraint(
            equalTo: superView.topAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
}
