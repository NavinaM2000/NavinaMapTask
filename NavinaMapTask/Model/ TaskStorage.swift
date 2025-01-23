//
//  TaskStorage.swift
//  MapTestNavinaM
//
//  Created by selvarani on 21/01/25.
//

import Foundation
import CoreLocation

class TaskStorage {
     let storageKey = "tasks"
    
    static let shared = TaskStorage()
    private init() {}
    
    func saveTasks(_ tasks: [Task]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(tasks) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    func fetchTasks() -> [Task] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Task].self, from: data)) ?? []
    }
    
}
