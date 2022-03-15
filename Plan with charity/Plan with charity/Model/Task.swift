//
//  Task.swift
//  Plan with charity
//
//  Created by Ilya Derezovskiy on 15.02.2022.
//

import SwiftUI

class Task: ObservableObject {
    //var id = UUID().uuidString
    @Published var name: String
    @Published var deadline: Date? = Date()
    @Published var notification: Bool
    @Published var annotation: String
    @Published var cost: Int
    @Published var isDone: Bool
    @Published var isDeleted: Bool = false
    
    init() {
        self.name = ""
        self.deadline = Date()
        self.annotation = ""
        self.cost = 0
        self.notification = false
        self.isDone = false
    }
    
    init (name: String?, deadline: Date?, annotation: String?, cost: Int?, notification: Bool?, isDone: Bool?){
        self.name = name ?? ""
        self.deadline = deadline ?? Date()
        self.annotation = annotation ?? ""
        self.cost = cost ?? 0
        self.notification = notification ?? false
        self.isDone = isDone ?? false
    }
    
    func getCost(cost: String) {
        self.cost = Int(cost) ?? 0
    }
}

func getSamleDate(offset: Int) -> Date {
    let calender = Calendar.current
    
    let date = calender.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}
