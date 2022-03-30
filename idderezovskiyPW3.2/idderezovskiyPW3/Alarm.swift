//
//  Alarm.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 29.03.2022.
//

import UIKit

struct Alarm {
    var alarmId: Int
    var alarmTime: Date
    var alarmName: String
    var isOn: Bool
}

struct AlarmModel {
    enum FetchAlarm {
        struct Request {
            let alarmId: Int
        }
        
        struct Response {
            struct Success {
                var alarm: Alarm
            }
            
            struct Error {
                var message: String
            }
            
            var success: Success?
            var error: Error?
        }
    }
    
    enum FetchAlarms {
        struct Request {
            
        }
        
        struct Response {
            var alarms: [Alarm]
        }
    }
    
    enum UpdateAlarm {
        struct Request {
            let alarmId: Int
        }
        
        struct Response {
            struct Success {
                var alarm: Alarm
            }
            
            struct Error {
                var message: String
            }
            
            var success: Success?
            var error: Error?
        }
    }
    
    enum EditAlarm {
        struct Request {
            let alarmId: Int
            let alarmName: String
            let alarmTime: Date
        }
        
        struct Response {
            struct Success {
            }
            
            struct Error {
                var message: String
            }
            
            var success: Success?
            var error: Error?
        }
    }
    
    enum AddAlarm {
        struct Request {
            var alarmName: String
            var alarmDate: Date
        }
        
        struct Response {
        }
    }
    
    struct ViewModel {
        struct DisplayedAlarm {
            var alarmTime: Date
            var isOn: Bool
            var alarmId: Int
            var alarmName: String
        }
        
        var displayedAlarms: [DisplayedAlarm]
    }
}

