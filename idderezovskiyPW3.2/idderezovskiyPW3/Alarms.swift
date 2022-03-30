//
//  Alarms.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 29.03.2022.
//

import UIKit
import EventKit

protocol AlarmsLogic {
    func addAlarm(_ request: AlarmModel.AddAlarm.Request)
    func fetchAlarm(_ request: AlarmModel.FetchAlarm.Request) -> AlarmModel.FetchAlarm.Response
    func fetchAlarms() -> AlarmModel.FetchAlarms.Response
    func updateAlarm(_ request: AlarmModel.UpdateAlarm.Request) -> AlarmModel.UpdateAlarm.Response
    func editAlarm(_ request: AlarmModel.EditAlarm.Request) -> AlarmModel.EditAlarm.Response
}

class Alarms : AlarmsLogic {
    private var alarms: [Alarm] = []
    
    init() { }
    
    init(alarms: [Alarm]) {
        self.alarms = alarms
    }
    
    func addAlertNotification(index: Int) {
        let content = UNMutableNotificationContent()
        content.title = alarms[index].alarmName ?? "No name"
        content.body = "Будильник, который Вы заводили"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName.init("bell.mp3"))

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm"
        let date = alarms[index].alarmTime
        
        let triger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: false)
        let reqest = UNNotificationRequest(identifier: "\(index)", content: content, trigger: triger)
        
        UNUserNotificationCenter.current().add(reqest) { (error) in return }
    }
    
    func addAlarm(_ request: AlarmModel.AddAlarm.Request) {
        let alarm = Alarm(
            alarmId: alarms.count + 1,
            alarmTime: request.alarmDate,
            alarmName: request.alarmName,
            isOn: true
        )
        alarms.append(alarm)
        addAlertNotification(index: alarm.alarmId - 1)
    }
    
    func fetchAlarm(_ request: AlarmModel.FetchAlarm.Request) -> AlarmModel.FetchAlarm.Response {
        let alarmId = request.alarmId
        
        for i in 0 ..< alarms.count {
            if (alarmId == alarms[i].alarmId) {
                return AlarmModel.FetchAlarm.Response(
                    success: AlarmModel.FetchAlarm.Response.Success(alarm: alarms[i]),
                    error: nil
                )
            }
        }
        
        return AlarmModel.FetchAlarm.Response(
            success: nil,
            error: AlarmModel.FetchAlarm.Response.Error(message: "Could not find alarm")
        )
    }
    
    func fetchAlarms() -> AlarmModel.FetchAlarms.Response {
        return AlarmModel.FetchAlarms.Response(alarms: alarms)
    }
    
    func updateAlarm(_ request: AlarmModel.UpdateAlarm.Request) -> AlarmModel.UpdateAlarm.Response {
        let alarmId = request.alarmId
        
        for i in 0 ..< alarms.count {
            if (alarmId == alarms[i].alarmId) {
                alarms[i].isOn = !alarms[i].isOn
                return AlarmModel.UpdateAlarm.Response(
                    success: AlarmModel.UpdateAlarm.Response.Success(alarm: alarms[i]),
                    error: nil
                )
            }
        }
        
        return AlarmModel.UpdateAlarm.Response(
            success: nil,
            error: AlarmModel.UpdateAlarm.Response.Error(message: "Could not find alarm")
        )
    }
    
    func editAlarm(_ request: AlarmModel.EditAlarm.Request) -> AlarmModel.EditAlarm.Response {
        let alarmId = request.alarmId
        let alarmTime = request.alarmTime
        let alarmName = request.alarmName
        
        for i in 0 ..< alarms.count {
            if (alarmId == alarms[i].alarmId) {
                alarms[i].alarmName = alarmName
                alarms[i].alarmTime = alarmTime
                return AlarmModel.EditAlarm.Response(
                    success: AlarmModel.EditAlarm.Response.Success(),
                    error: nil
                )
            }
        }
        
        return AlarmModel.EditAlarm.Response(
            success: nil,
            error: AlarmModel.EditAlarm.Response.Error(message: "Could not find alarm")
        )
    }
}

