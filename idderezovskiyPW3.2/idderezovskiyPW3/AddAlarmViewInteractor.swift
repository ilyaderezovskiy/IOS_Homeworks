//
//  AddAlarmViewInteractor.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 30.03.2022.
//

import Foundation

protocol AddAlarmViewInteractorLogic: AddAndEditAlarmInteractorLogic {
    func addAlarm(alarmTime: Date)
}

class AddAlarmViewInteractor : AddAlarmViewInteractorLogic {
    var alarmStore: AlarmsLogic!
    var listInteractor: ViewLogic!
    var presenter: AddAndEditAlarmViewPresenterLogic!
    var currentAlarmName: String = "Alarm"
    
    init(interactor: ViewLogic, presenter: AddAndEditAlarmViewPresenter) {
        self.presenter = presenter
        self.listInteractor = interactor
        self.alarmStore = interactor.alarmStore
    }

    func updateCurrentAlarmName(_ alarmName: String) {
        currentAlarmName = alarmName
        presenter.updateAlarmName(alarmName)
    }

    func addAlarm(alarmTime: Date) {
        let request = AlarmModel.AddAlarm.Request(
            alarmName: currentAlarmName,
            alarmDate: alarmTime
        )
        
        alarmStore.addAlarm(request)
        listInteractor?.presentAlarms()
    }
}

