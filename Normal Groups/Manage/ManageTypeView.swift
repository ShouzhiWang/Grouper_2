//
//  ManageTypeView.swift
//  
//
//  Created by 王首之 on 1/17/24.
//

import SwiftUI

struct ManageTypeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var DM : DataManager
    @State private var selectedType : String = ""
    @State private var listItemEntries: [ListItemEntry] = []
    @State private var showingAlert = false
    @State private var cannotSave = false
    
    
    var body: some View {
        NavigationStack{
            List{
                ForEach($listItemEntries) { $name in
                    Section{
                        
                        
                        
                        TextField("Please type", text: $name.text)
                        
                            .disableAutocorrection(true)
                            
                        
                        
                    } header: {
                        Text("Rename")
                    }
                }
                
                if listItemEntries.isEmpty {
                    Text("Empty")
                }
                
                if listItemEntries.count >= 4 {
                    Button {
                        //withAnimation {
                            listItemEntries.removeLast()
                        //}
                    } label: {
                        Label("Remove Additional Type", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
                
                if listItemEntries.count <= 5 {
                    Button {
                        withAnimation {
                            listItemEntries.append(ListItemEntry(text: ""))
                        }
                    } label: {
                        Label("Add Type", systemImage: "plus")
                            
                    }
                }
                
                Button {
                    withAnimation {
                        listItemEntries = []
                        for x in ["Student", "Teacher", "Staff"] {
                            listItemEntries.append(ListItemEntry(text: x))
                       }
                    }
                } label: {
                    Label("Reset", systemImage: "arrow.uturn.backward")
                        
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
                        for i in 0...listItemEntries.count - 1 {
                            if listItemEntries[i].text.trimmingCharacters(in: .whitespaces) == "" {
                                listItemEntries[i].text = ""
                                showingAlert = true
                                cannotSave = true
                                break
                            }
                            cannotSave = false
                        }
                        if cannotSave == false {
                            DM.personTypes = []
                            for x in 0...listItemEntries.count - 1 {
                                DM.personTypes.append(listItemEntries[x].text.trimmingCharacters(in: .whitespaces))
                            
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    }

                    } label: {
                        Text("Save")
                            .font(.body)
                            .fontWeight(.bold)

                    }
                }
                
                
            }
            .navigationTitle("Edit Types")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .onAppear {
            for x in DM.personTypes {
                listItemEntries.append(ListItemEntry(text: x))
                
            }
        }
        
        .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Unable to save"), message: Text("Please make sure there aren't any blank names"), dismissButton: .default(Text("OK")))
                }
    }
    struct ListItemEntry: Identifiable {
        let id = UUID()
        var text: String
    }
    
}

#Preview {
    ManageTypeView(DM: DataManager())
}
