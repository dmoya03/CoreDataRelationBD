//
//  addGoalView.swift
//  CoreDataTwo
//
//  Created by Daniel Moya on 21/5/24.
//

import SwiftUI

struct addGoalView: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var model = GoalsViewModel()
    
    var body: some View {
        VStack{
            TextField("Title", text: $model.title).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Description", text: $model.desc).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                if model.title.isEmpty{
                    showToast(message: "The Title field is required. Please write a title.")
                } else {
                    model.saveData(context: context)
                }
            }){
                Text("Save")
            }
            Spacer()
        }.padding()
    }
}
