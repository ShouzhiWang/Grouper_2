//
//  AddPersonView.swift
//  
//
//  Created by 王首之 on 1/16/24.
//

import SwiftUI
import CoreData

struct AddPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjContext
    @ObservedObject var DM : DataManager
    @State private var tempname : String = ""
    @State private var selectedClass : String = ""
    @State private var selectedPersonality : String = ""
    @State private var selectedType : String = ""
    @State var inputClass : String?
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<People>
    var body: some View {
        NavigationStack{

            List {
                
                Section{
                    TextField("Name", text: $tempname)
                        //.padding(.all)
                        //.textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                    
                    
                } footer: {
                    if tempname.count <= 15 {
                        Text(String(tempname.count) + "/15")
                            
                    } else {
                        Text(String(tempname.count) + "/15")
                            
                            .foregroundColor(Color.red)
                    }
                }
                
                Section {
                    if DM.classNames.isEmpty {
                        Text("You don't have any classes yet. Please add one prior to adding any person.")
                            .foregroundColor(.red)
                    } else {
                        let _ = selectedClass
                        Picker("Class", selection: $selectedClass) {
                            ForEach(DM.classNames, id: \.self) { x in
                                Text(x)
                                    .tag(x)
                            }
                        }.disabled(inputClass != nil)
                    }
                }
                
                Section {
                    Picker("Personality (Optional)", selection: $selectedPersonality) {
                        ForEach(DM.personalities, id: \.self) { x in
                            Text(x)
                                .tag(x)
                        }
                    }
                }
                
                Section {
                    Picker("Type (Optional)", selection: $selectedType) {
                        ForEach(DM.personTypes, id: \.self) { x in
                            Text(x)
                                .tag(x)
                        }
                    }.pickerStyle(.segmented)
                    
                    
                } header: {
                    Text("Type (Optional)")
                } footer: {
                    if !selectedType.isEmpty {
                        Button("Clear") {
                            selectedType = ""
                        }
                    }
                }
                
               
            }
            
            
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button{
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    let instance = People(context: managedObjContext)
                    instance.myId = UUID()
                    instance.name = tempname
                    instance.category = selectedClass
                    instance.type = selectedType
                    instance.personality = selectedPersonality
                    save(context: managedObjContext)
                    //saveName()
                    presentationMode.wrappedValue.dismiss()

                } label: {
                    Text("Save")
                        .font(.body)
                        .fontWeight(.bold)

                }.disabled(tempname.count > 15 || tempname.count == 0 || DM.classNames.isEmpty)
            }
            
            
        }
        .navigationTitle("Add Person")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !DM.classNames.isEmpty {
                self.selectedClass = DM.classNames[0]
            }
            if (inputClass != nil) {
                self.selectedClass = inputClass!
            }
        }
            
        
            
        }
    }
    
    
    func save(context: NSManagedObjectContext) {
            do {
                try context.save()
                
            } catch {
                print("FAILED to save the data")
            }
            
        }
}

#Preview {
    AddPersonView(DM: DataManager())
}
