//
//  EditView.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 29.03.2022.
//

import Foundation

protocol EditViewInteractorLogic: AddAndEditAlarmInteractorLogic  {
    var alarmId: Int! { get set }
    func editAlarm(alarmId: Int, alarmTime: Date)
}

class EditViewInteractor: EditViewInteractorLogic {
    var alarmStore: AlarmsLogic!
    var listInteractor: ViewLogic!
    var presenter: AddAndEditAlarmViewPresenterLogic!
    var currentAlarmName: String = "Alarm"
    var alarmId: Int!
    
    init(interactor: ViewLogic, presenter: AddAndEditAlarmViewPresenter) {
        self.presenter = presenter
        self.listInteractor = interactor
        self.alarmStore = interactor.alarmStore
    }
    
    func updateCurrentAlarmName(_ alarmName: String) {
        currentAlarmName = alarmName
        presenter.updateAlarmName(alarmName)
    }
    
    func editAlarm(alarmId: Int, alarmTime: Date) {
        let request = AlarmModel.EditAlarm.Request(
            alarmId: alarmId,
            alarmName: currentAlarmName,
            alarmTime: alarmTime
        )
        
        if let successResponse = alarmStore.editAlarm(request).success {
            listInteractor?.presentAlarms()
        }
    }
}

