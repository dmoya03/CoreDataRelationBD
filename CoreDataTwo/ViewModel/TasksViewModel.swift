//
//  TasksViewModel.swift
//  CoreDataTwo
//
//  Created by Daniel Moya on 21/5/24.
//

import Foundation
import CoreData

class TasksViewModel: ObservableObject {
    @Published var task = ""
    
    func saveData(context: NSManagedObjectContext, goal: Goals){
        
        let newTask = Tasks(context: context)
        newTask.task = task
        newTask.id = UUID().uuidString
        newTask.idGoal = goal.id
        goal.mutableSetValue(forKey: "relationToTasks").add(newTask)
        
        do{
            try context.save()
            print("Good | Saved")
        } catch let error as NSError {
            print("Fail - Error saving", error.localizedDescription)
        }
        
    }
    
    
}
