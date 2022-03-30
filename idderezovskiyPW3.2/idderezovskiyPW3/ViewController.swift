//
//  ViewController.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 29.03.2022.
//

import UIKit

class ViewController: UIViewController {
    var interactor: ViewLogic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(showAddScreen)
        )
        self.navigationItem.rightBarButtonItem?.tintColor = .blue
    }
    
    @objc
    func showAddScreen() {
        let addAlarmVC = AddAlarmViewController()
        addAlarmVC.interactor = AddAlarmViewInteractor (
            interactor: interactor,
            presenter: AddAndEditAlarmViewPresenter(addAlarmVC)
        )
        
        let navVC = UINavigationController(rootViewController: addAlarmVC)
        navVC.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        navVC.navigationBar.tintColor = .black
        navVC.setAppearance()
        
        present(navVC, animated: true, completion: nil)
    }
    
    func updateAlarm(_ alarmId: Int) {
        interactor?.updateAlarm(alarmId)
    }
    
    func editAlarm(_ alarmId: Int) {
        interactor?.editAlarm(alarmId)
    }
    
    func presentEditScreen(_ alarm: AlarmModel.ViewModel.DisplayedAlarm) {
        let editAlarmVC = EditViewController (alarm)
        editAlarmVC.interactor = EditViewInteractor (
            interactor: interactor,
            presenter: AddAndEditAlarmViewPresenter(editAlarmVC)
        )
        
        let navVC = UINavigationController(rootViewController: editAlarmVC)
        navVC.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        navVC.navigationBar.tintColor = .blue
        navVC.setAppearance()
        
        present(navVC, animated: true, completion: nil)
    }
}

extension UINavigationController {
    func setAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .lightGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
}
