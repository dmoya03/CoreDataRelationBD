//
//  GoalsViewModel.swift
//  CoreDataTwo
//
//  Created by Daniel Moya on 21/5/24.
//

import Foundation
import CoreData

class GoalsViewModel: ObservableObject {
    @Published var title = ""
    @Published var desc = ""
    
    func saveData(context: NSManagedObjectContext){
        
        let newGoal = Goals(context: context)
        newGoal.title = title
        newGoal.desc = desc
        newGoal.id = UUID().uuidString

        do{
            try context.save()
            print("Good | Saved")
        } catch let error as NSError {
            print("Fail - Error saving", error.localizedDescription)
        }
        
    }
    
    func deleteData(item: Goals, context: NSManagedObjectContext){
        context.delete(item)
        do{
            try context.save()
            print("Good | Deleted")
        } catch let error as NSError {
            print("Fail - Deletion error", error.localizedDescription)
        }
        
    }
}
