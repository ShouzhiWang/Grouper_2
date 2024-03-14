//
//  ClassDetailView.swift
//  
//
//  Created by 王首之 on 1/17/24.
//

import SwiftUI
import CoreData

struct ClassDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<People>
    @State private var sheetUp = false
    @State private var showingAlert = false
    @ObservedObject var DM : DataManager
    @State var className: String
    
    var body: some View {
        
        
        List {
            if people.filter({$0.category == className}).isEmpty {
                Text("You don't have any person in this class yet. Add a person first.")
                    .foregroundColor(.red)
            }
            ForEach(people.filter {$0.category == className}) { instance in
                HStack{
                    Text(instance.name)
                    if instance.type != nil && instance.type != "" {
                        Text(instance.type!)
                            .textCase(.uppercase)
                            .padding(.horizontal, 3.0)
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .background(RoundedRectangle(cornerRadius: 3)
                                .fill(Color("terLabelColor"))
                            )
                    }
                    if instance.personality != nil && instance.personality != "" {
                        Text(instance.personality!)
                            .textCase(.uppercase)
                            .padding(.horizontal, 3.0)
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .background(RoundedRectangle(cornerRadius: 3)
                                .fill(Color("personaLabelColor"))
                            )
                    }
                }
            }.onDelete(perform: deleteItems)
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAlert.toggle()
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                
                
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    sheetUp.toggle()
                } label: {
                    Image(systemName: "person.crop.circle.badge.plus")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        
        .sheet(isPresented: $sheetUp){
            AddPersonView(DM: DM, inputClass: className)
        }
        .navigationTitle(className)
        
        .alert("Are you sure?", isPresented: $showingAlert) {
            
            Button("Cancel", role: .cancel) {}
            Button("Confirm", role: .destructive) {
                withAnimation{
                    if !people.filter({$0.category == className}).isEmpty {
                        for instance in people  {
                            if instance.category == className {
                                managedObjContext.delete(instance)
                            }
                            
                        }
                        do {
                            try managedObjContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                    
                    DM.classNames.removeAll(where: { $0 == className })
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            
        } message: {
            Text("You are deleting the class '\(className)'")
        }
                
    }
    
    private func deleteItems(offsets: IndexSet) {
            withAnimation {
                offsets.map { people[$0] }.forEach(managedObjContext.delete)

                do {
                    try managedObjContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
            
            
            
        }
}

#Preview {
    ClassDetailView(DM: DataManager(), className: "Class 1")
}
