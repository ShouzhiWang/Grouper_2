//
//  Manage.swift
//  
//
//  Created by 王首之 on 1/14/24.
//

import SwiftUI
import CoreData

struct Manage: View {
    @ObservedObject var DM : DataManager
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<People>
    @State private var sheetUp = false
    @State private var sheet2Up = false
    @State private var sheet3Up = false
    @State private var tempname : String = ""
    @State private var tempClassName : String = ""
    @State private var selectedClass : String = "...Please Select"
    
    
    var body: some View {
            List {
                
                Section{
                    VStack{
                        HStack {
                            
                            Button{
                                sheetUp.toggle()
                            } label: {
                                VStack{
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        
                                        .font(.title)
                                    Text("New Person")
                                }
                            }.buttonStyle(BorderlessButtonStyle())
                                .frame(maxWidth: .infinity)
                            
                            
                            Divider()
                            
                            Button{
                                sheet2Up.toggle()
                            } label: {
                                VStack{
                                    Image(systemName: "plus.square.on.square")
                                        
                                        .font(.title)
                                    Text("New Class")
                                }
                            }.buttonStyle(BorderlessButtonStyle())
                                .frame(maxWidth: .infinity)
                                
                            Divider()
                            
                            Button{
                                sheet3Up.toggle()
                            } label: {
                                VStack{
                                    Image(systemName: "person.text.rectangle")
                                        
                                        .font(.title)
                                    Text("Edit Types")
                                }
                            }.buttonStyle(BorderlessButtonStyle())
                                .frame(maxWidth: .infinity)
                        }
                        
                        
                    }
                }
                
                Section{
                    ForEach(DM.classNames, id: \.self) { x in
                        NavigationLink {
                            ClassDetailView(DM: DM, className: x)
                        } label: {
                            Text(x)
                        }
                        
                    }/*.onDelete(perform: deleteItems)*/
                    
                    
                } header: {
                    if DM.classNames.isEmpty {
                        
                        Text("You currently do not have any classes nor people added. Please add a new class and then start to add people.")
                        
                        
                    }else {
                        Text("Your Classes")
                    }
                }
            
                
            }
       
            .navigationTitle("Manage")
 
            .sheet(isPresented: $sheetUp, content: {
                AddPersonView(DM: DM)
            }
            
            
            )
        
            .sheet(isPresented: $sheet3Up, content: {
                ManageTypeView(DM: DM)
                
            })
        
            .sheet(isPresented: $sheet2Up, content: {
                VStack{
                    HStack{
                        Button{
                            sheet2Up = false
                        } label: {
                            Text("Cancel")
                        }
                        Spacer()
                        Button{
                            if DM.classNames.isEmpty {
                                DM.classNames = []
                            }
                            DM.classNames.append("\(tempClassName)")
                            tempClassName = ""
                            sheet2Up = false
                            
                        } label: {
                            Text("Save")
                                .font(.body)
                                .fontWeight(.bold)
                            
                        }.disabled(tempClassName.count > 15 || tempClassName.count == 0 || !DM.classNames.filter({$0 == tempClassName}).isEmpty)
                    }.padding(.all)
                    
                    Image(systemName: "person.crop.circle.badge.plus")
                        
                        .font(.largeTitle)
                        .padding(.all)
                    
                    
                    Text("New Class")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    

                    
                    HStack{
                        TextField("Name", text: $tempClassName)
                            .padding(.all)
                            .textFieldStyle(.roundedBorder)
                            .disableAutocorrection(true)
                        if tempClassName.count <= 15 {
                            Text(String(tempClassName.count) + "/15")
                                .padding(.trailing)
                        } else {
                            Text(String(tempClassName.count) + "/15")
                                .padding(.trailing)
                                .foregroundColor(Color.red)
                        }
                        
                    }
                    if !DM.classNames.filter({$0 == tempClassName}).isEmpty {
                        Text("Class names cannot repeat")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    
                    Spacer()
                }
                
            })
        
        
    }
        
    private func deleteItems(offsets: IndexSet) {
            //withAnimation {
        var tempClasses:[String] = []
                for index in offsets {
                    tempClasses.append(DM.classNames[index])
                }
                
                DM.classNames.remove(atOffsets: offsets)
                
        for x in 0..<tempClasses.count {
                    for instance in people  {
                        if instance.category == tempClasses[x] {
                            managedObjContext.delete(instance)
                        }
                        
                    }

                }
                
                do {
                    try managedObjContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            
            
        }
}

#Preview {
    Manage(DM: DataManager())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
