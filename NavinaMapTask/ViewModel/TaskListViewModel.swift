//
//  TaskListViewModel.swift
//  NavinaMapTask
//
//  Created by selvarani on 22/01/25.
//

import Foundation
import CoreLocation

class TaskListViewModel {
    private(set) var tasks: [Task] = []
    var onTasksUpdated: (() -> Void)?
    
    init() {
        tasks = TaskStorage.shared.fetchTasks()
    }
    
    func addTask(title: String, description: String, location: CLLocationCoordinate2D) {
        let newTask = Task(id: UUID(), title: title, description: description, location: location)
        tasks.append(newTask)
        saveTasks()
    }
    
    func saveTasks() {
        TaskStorage.shared.saveTasks(tasks)
        onTasksUpdated?()
    }
}
