//
//  StackViewController.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 29.03.2022.
//

import UIKit

class StackViewController: ViewController {
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Stack"
        
        var tabBarItem = UITabBarItem()
        tabBarItem = UITabBarItem(
            title: "Stack",
            image: UIImage(named: "stack"),
            selectedImage: UIImage(named: "stack")
        )
        self.tabBarItem = tabBarItem
        
        setupStackView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView?.contentSize = CGSize(
            width: self.view.frame.width,
            height: stackView.frame.height
        )
        scrollView.backgroundColor = .white
    }
    
    func setupStackView() {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.addSubview(scrollView)
        scrollView.pin(to: view)
        self.scrollView = scrollView
        
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 0
        scrollView.addSubview(stackView)
        stackView.pinLeft(to: view.leadingAnchor)
        stackView.pinRight(to: view.trailingAnchor)
        self.stackView = stackView
    }
    
    func updateData(_ data: AlarmModel.ViewModel) {
        if let stackView = stackView {
            for subview in stackView.arrangedSubviews {
                subview.removeFromSuperview()
            }
        }
        
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
            alarmView.setHeight(to: Double(AlarmView.viewHeight))

            stackView?.addArrangedSubview(alarmView)
        }
    }
    
    func updateAndPresentAlarm(_ alarmViewModel: AlarmModel.ViewModel.DisplayedAlarm) {
        let alarmId = alarmViewModel.alarmId
        let alarmTime = alarmViewModel.alarmTime
        let isOn = alarmViewModel.isOn
        let alarmName = alarmViewModel.alarmName
        
        for i in 0 ..< stackView.arrangedSubviews.count {
            guard var alarmView = (stackView.arrangedSubviews[i] as? AlarmView) else { return }
            
            if alarmView.getAlarmId() == alarmViewModel.alarmId {
                let view = stackView.arrangedSubviews[i]
                stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
                
                let newView = AlarmView(
                    updateAction: self.updateAlarm,
                    edit: self.editAlarm,
                    alarmId: alarmId,
                    alarmName: alarmName,
                    alarmTime: alarmTime,
                    isOn: isOn
                )
                newView.setHeight(to: Double(AlarmView.viewHeight))
                
                stackView.insertArrangedSubview(newView, at: i)
            }
        }
    }
}

