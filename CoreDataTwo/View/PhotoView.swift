//
//  PhotoView.swift
//  CoreDataTwo
//
//  Created by Daniel Moya on 21/5/24.
//

import SwiftUI

struct PhotoView: View {
    
    var task: Tasks
    @Environment(\.managedObjectContext) var context
    //@FetchRequest(entity: Tasks.entity(), sortDescriptors: []) var tasks: FetchedResults<Tasks>
    var photos: FetchRequest<Photos>
    @State private var imageData : Data = .init(capacity: 0)
    @State private var mostrarMenu = false
    @State private var imagePicker = false
    @State private var source : UIImagePickerController.SourceType = .camera
    let gridItem: [GridItem] = Array(repeating: .init(.flexible(maximum: 100)), count: 3)
    
    init(task: Tasks) {
        self.task = task
        photos = FetchRequest(entity: Photos.entity(), sortDescriptors: [], predicate: NSPredicate(format: "idTask == %@", task.id!))
    }
    
    func save(image: Data){
        let newPhoto = Photos(context: context)
        newPhoto.photo = image
        newPhoto.idTask = task.id
        
        task.mutableSetValue(forKey: "relationToPhotos").add(newPhoto)
        
        do{
            try context.save()
            print("Good | Saved")
        } catch let error as NSError {
            print("Fail - Error saving", error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: ImagePicker(show: self.$imagePicker, image: self.$imageData, source: self.source), isActive: self.$imagePicker) {
                    Text("")
                }.navigationBarTitle("")
                    .navigationBarHidden(true)
                
                ScrollView(){
                    LazyVGrid(columns: gridItem, spacing: 10){
                        ForEach(photos.wrappedValue){ photo in
                            Image(uiImage: UIImage(data: photo.photo ?? Data())!)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
                
                HStack(alignment: .center, spacing: 60){
                    Button(action:{
                        self.mostrarMenu.toggle()
                    }){
                        Image(systemName: "camera")
                    }.actionSheet(isPresented: self.$mostrarMenu) {
                        ActionSheet(title: Text("Menu"), message: Text("Select an option"), buttons: [
                            .default(Text("Camera"), action: {
                                self.source = .camera
                                self.imagePicker.toggle()
                            }),
                            .default(Text("Gallery"), action: {
                                self.source = .photoLibrary
                                self.imagePicker.toggle()
                            }),
                            .default(Text("Cancel"))
                        ])
                    }
                    
                    Button(action: {
                        if imageData.isEmpty{
                            showToast(message: "Select the camera button")
                        } else {
                            save(image: imageData)
                        }
                    }){
                        Text("Save Image")
                    }
                }
            }
        }
    }
}


