//
//  addTaskView.swift
//  CoreDataTwo
//
//  Created by Daniel Moya on 21/5/24.
//

import SwiftUI

struct addTaskView: View {
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var model = TasksViewModel()
    var goal: Goals
    
    var body: some View {
        VStack{
            TextField("Task", text: $model.task).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                if model.task.isEmpty {
                    showToast(message: "The Task field is required")
                } else {
                    model.saveData(context: context, goal: goal)
                }
            }){
                Text("Save")
            }
        }.padding()
    }
}

