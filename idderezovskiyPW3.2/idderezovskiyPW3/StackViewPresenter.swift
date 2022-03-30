//
//  StackView.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 29.03.2022.
//

import Foundation

class StackViewPresenter : ViewPresenter {
    weak var stackVC: StackViewController?
    
    init(_ stackVC: StackViewController) {
        self.stackVC = stackVC
    }
    
    func presentAlarmEditScreen(_ response: AlarmModel.FetchAlarm.Response.Success) {
        let alarm = response.alarm
        
        let displayedAlarm = AlarmModel.ViewModel.DisplayedAlarm(
            alarmTime: alarm.alarmTime,
            isOn: alarm.isOn,
            alarmId: alarm.alarmId,
            alarmName: alarm.alarmName
        )
        
        stackVC?.presentEditScreen(displayedAlarm)
    }
    
    func updateAndPresentAlarm(_ response: AlarmModel.UpdateAlarm.Response.Success) {
        let alarm = response.alarm
        
        let displayedAlarm = AlarmModel.ViewModel.DisplayedAlarm(
            alarmTime: alarm.alarmTime,
            isOn: alarm.isOn,
            alarmId: alarm.alarmId,
            alarmName: alarm.alarmName
        )
        
        stackVC?.updateAndPresentAlarm(displayedAlarm)
    }
    
    func presentAlarms(_ response: AlarmModel.FetchAlarms.Response) {
        let alarms = response.alarms.sorted {
            $0.alarmTime < $1.alarmTime
        }
        
        var displayedAlarms: [AlarmModel.ViewModel.DisplayedAlarm] = []
        for i in 0 ..< alarms.count {
            let alarm = alarms[i]
            
            displayedAlarms.append(
                AlarmModel.ViewModel.DisplayedAlarm(
                    alarmTime: alarm.alarmTime,
                    isOn: alarm.isOn,
                    alarmId: alarm.alarmId,
                    alarmName: alarm.alarmName
                )
            )
        }
        
        // Presenting data.
        stackVC?.updateData(AlarmModel.ViewModel(displayedAlarms: displayedAlarms))
    }
}

