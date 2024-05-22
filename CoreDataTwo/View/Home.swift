//
//  Home.swift
//  CoreDataTwo
//
//  Created by Daniel Moya on 21/5/24.
//

import SwiftUI
import CoreData

struct Home: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Goals.entity(), sortDescriptors: []) var goals: FetchedResults<Goals>
    @ObservedObject var model = GoalsViewModel()
    @State private var search = ""
    
    var body: some View {
        NavigationView{
            VStack{
                SearchBar(text: $search)
                List{
                    ForEach(goals.filter{
                        search.isEmpty ? true : $0.title!.lowercased().contains(search.lowercased())
                    }){goal in
                        NavigationLink(destination: TasksView(goal: goal)){
                            VStack(alignment: .leading){
                                Text(goal.title ?? "").font(.title)
                                Text(goal.desc ?? "").font(.headline)
                            }
                        }
                    }.onDelete{ (IndexSet) in
                        let goalSelected = goals[IndexSet.first!]
                        model.deleteData(item: goalSelected, context: context)
                    }
                }
                NavigationLink(destination: addGoalView()){
                    Image(systemName: "note")
                }
            }.navigationBarTitle("Goals")
        }
    }
}
