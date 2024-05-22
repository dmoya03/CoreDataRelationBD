//
//  TasksView.swift
//  CoreDataTwo
//
//  Created by Daniel Moya on 21/5/24.
//

import SwiftUI

struct TasksView: View {
    var goal: Goals
    @Environment(\.managedObjectContext) var context
    //@FetchRequest(entity: Tasks.entity(), sortDescriptors: []) var tasks: FetchedResults<Tasks>
    var tasks: FetchRequest<Tasks>
    
    init(goal: Goals) {
        self.goal = goal
        tasks = FetchRequest(entity: Tasks.entity(), sortDescriptors: [], predicate: NSPredicate(format: "idGoal == %@", goal.id!))
    }
    var body: some View {
        VStack{
            List{
                ForEach(tasks.wrappedValue){task in
                    NavigationLink(destination: PhotoView(task: task)){
                        VStack(alignment: .leading){
                            Text(task.task ?? "").font(.title)
                        }
                    }
                }
            }
            NavigationLink(destination: addTaskView(goal: goal)){
                Image(systemName: "plus")
            }
        }.navigationBarTitle(goal.title ?? "")
    }
}
