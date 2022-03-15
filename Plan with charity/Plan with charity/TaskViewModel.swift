//
//  TaskViewModel.swift
//  Plan with charity
//
//  Created by Ilya Derezovskiy on 16.02.2022.
//

import SwiftUI

class TaskViewModel: ObservableObject {

    @Published var tasks: [Task] = [
        Task(name: "Подготовить презентацию", deadline: getSamleDate(offset: -1), notification: getSamleDate(offset: 1), annotation: "14 done", cost: 100, isDone: true),
        
        Task(name: "Подготовить презентацию", deadline: getSamleDate(offset: 0), notification: getSamleDate(offset: 1), annotation: "15", cost: 100, isDone: false),
        
        Task(name: "Подготовить презентацию", deadline: getSamleDate(offset: -1), notification: getSamleDate(offset: 1), annotation: "14", cost: 100, isDone: false),
        
        Task(name: "Подготовить презентацию", deadline: getSamleDate(offset: 1), notification: getSamleDate(offset: 1), annotation: "16", cost: 100, isDone: false),
        
        Task(name: "Подготовить презентацию", deadline: getSamleDate(offset: 1), notification: getSamleDate(offset: 1), annotation: "16", cost: 100, isDone: false),
        
        Task(name: "Подготовить презентацию", deadline: getSamleDate(offset: 1), notification: getSamleDate(offset: 1), annotation: "16 done", cost: 100, isDone: true)
    ]
}
