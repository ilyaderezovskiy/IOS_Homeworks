//
//  AddAndEditAlarmViewPresenter.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 30.03.2022.
//

import Foundation

protocol AddAndEditAlarmViewPresenterLogic {
    func updateAlarmName(_ alarmName: String)
}

class AddAndEditAlarmViewPresenter: AddAndEditAlarmViewPresenterLogic {
    var addAndEditAlarmVC: AddAndEditViewControllerLogic?
    
    init(_ addAndEditAlarmVC: AddAndEditViewControllerLogic) {
        self.addAndEditAlarmVC = addAndEditAlarmVC
    }

    func updateAlarmName(_ alarmName: String) {
        addAndEditAlarmVC?.updateAlarmName(alarmName)
    }
}
