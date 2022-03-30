//
//  ViewLogic.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 29.03.2022.
//

import Foundation

protocol ViewLogic {
    var alarmStore: AlarmsLogic! { get }
    func editAlarm(_ alarmId: Int)
    func updateAlarm(_ alarmId: Int)
    func presentAlarms()
}

class AlarmListInteractor : ViewLogic {
    var alarmStore: AlarmsLogic!
    var presenters: [ViewPresenter?] = []
    
    init(_ alarmStore: AlarmsLogic) {
        self.alarmStore = alarmStore
    }
    
    func editAlarm(_ alarmId: Int) {
        let request = AlarmModel.FetchAlarm.Request(alarmId: alarmId)
        if let successResponse = alarmStore.fetchAlarm(request).success {
            for presenter in presenters {
                presenter?.presentAlarmEditScreen(successResponse)
            }
        }
    }
    
    func updateAlarm(_ alarmId: Int) {
        let request = AlarmModel.UpdateAlarm.Request(alarmId: alarmId)
        if let successResponse = alarmStore.updateAlarm(request).success {
            for presenter in presenters {
                presenter?.updateAndPresentAlarm(successResponse)
            }
        }
    }
    
    func presentAlarms() {
        let response = alarmStore.fetchAlarms()
        
        for i in 0 ..< presenters.count {
            presenters[i]?.presentAlarms(response)
        }
    }
}

