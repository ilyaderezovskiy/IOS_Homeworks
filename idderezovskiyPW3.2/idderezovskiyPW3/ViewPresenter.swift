//
//  ViewPresenter.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 29.03.2022.
//

import Foundation

protocol ViewPresenter {
    func presentAlarmEditScreen(_ response: AlarmModel.FetchAlarm.Response.Success)
    func presentAlarms(_ response: AlarmModel.FetchAlarms.Response)
    func updateAndPresentAlarm(_ response: AlarmModel.UpdateAlarm.Response.Success)
}
