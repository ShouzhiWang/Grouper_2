//
//  SelectPersonView.swift
//
//
//  Created by 王首之 on 1/23/24.
//

import SwiftUI

struct SelectPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<People>
    @State private var sheetUp = false
    @ObservedObject var DM : DataManager
    @State var className: String
    @State private var selection = Set<People>()
    @State private var editMode = EditMode.active
    @State private var selectAll = true
    @State private var numGroups: Int = 2
    @State private var selectedType: Int = 0
    var groupingMode: String?
    
    var body: some View {
        
        List(selection: $selection) {
            Section{
                if groupingMode == "Personality Grouping" {
                    Picker("Mode", selection: $selectedType) {
                        Text("Temperament")
                            .tag(0)
                        Text("Introverts/Extraverts")
                            .tag(1)
                        
                    }.pickerStyle(.segmented)
                } else if groupingMode == "Group Game" {
                    Picker("Mode", selection: $selectedType) {
                        Text("Random")
                            .tag(0)
                        Text("Temperament")
                            .tag(1)
                        Text("Introverts/Extraverts")
                            .tag(2)
                        
                    }.pickerStyle(.segmented)
                }
            }
            
            header: {
                if groupingMode == "Personality Grouping" || groupingMode == "Group Game" {
                    Text("Grouping Mode")
                }
                
            }
            
            if people.filter({$0.category == className}).isEmpty {
                Text("You don't have any person in this class yet. Add a person first.")
                    .foregroundColor(.red)
            }
            ForEach(people.filter {$0.category == className}, id: \.self) { instance in
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
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
        
        
        .environment(\.editMode, $editMode)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if self.selectAll {
                        
                        people.filter {$0.category == className}.forEach {item in
                            selection.insert(item)
                        } }else{
                            selection = Set<People>()
                        }
                        self.selectAll.toggle() } label: {
                        Text(self.selectAll ? "Seleact All" : "Deselect All")
                                            
                    }
                
                
                
            }
            
            ToolbarItem(placement: .bottomBar) {
                

                    
                    HStack {
                        if (selection.count < 3) {
                            Text("You do not have enough people to make groups")
                                .padding(.horizontal)
                        } else {
                            
                                
                                
                                Stepper("Make \(numGroups) Groups", value: $numGroups, in: 2...getMaxGroupNum())
                                    .padding(.horizontal)
                            
                        }
                        

                        Spacer()
                        
                        
                        
                        Button {
        
                            if groupingMode == "Personality Grouping" {
                                if selectedType == 0 {
                                    DM.groupByPersonality(Array(selection), intoGroups: numGroups)
                                } else if selectedType == 1 {
                                    DM.groupByPersonalityIE(Array(selection), intoGroups: numGroups)
                                }
                            } else {
                                DM.getRandomGroups(input: selection, numberOfGroups: numGroups)
                            }
                            sheetUp.toggle()
                        } label: {
                            Image(systemName: "arrow.forward")
                                .frame(height: 15)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .clipShape(Circle())
                        .padding(.trailing)
                        
                        .disabled(selection.count < 3)
                        
                        
                        
                        

                    }
                    
                
            }
        }
        
        .sheet(isPresented: $sheetUp) {
            if groupingMode == "Group Game" {
                GameGroupedView(DM: DM, groupingMode: groupingMode, selectedType: selectedType)
                    .ignoresSafeArea(.all)
            } else {
                
                NormalGroupedView(DM: DM, groupingMode: groupingMode, selectedType: selectedType)
            }
        }
        
    }
    
    func getMaxGroupNum () -> Int {
        if selection.count < 4 {
            return 3
        } else {
            return selection.count - 1
        }
    }
}

#Preview {
    SelectPersonView(DM: DataManager(), className: "Class1")
}
