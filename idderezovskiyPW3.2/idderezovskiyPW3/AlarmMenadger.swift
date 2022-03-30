//
//  AlarmMenadger.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 22.03.2022.
//

import UIKit

protocol SceneConfiguratorLogic {
    static func configureScene(collectionVC: CollectionViewController, tableVC: TableViewController, stackVC: StackViewController)
}

final class AlarmMenadger : SceneConfiguratorLogic {
    static func configureScene(collectionVC: CollectionViewController, tableVC: TableViewController, stackVC: StackViewController) {
        let alarmStore = Alarms(alarms: [])
        let interactor = AlarmListInteractor(alarmStore)
        
        collectionVC.interactor = interactor
        tableVC.interactor = interactor
        stackVC.interactor = interactor
        
        interactor.presenters = [
            CollectionViewPresenter(collectionVC),
            TableViewPresenter(tableVC),
            StackViewPresenter(stackVC)
        ]
        
        interactor.presentAlarms()
    }
}
