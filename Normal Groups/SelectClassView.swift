//
//  SelectClassView.swift
//  
//
//  Created by 王首之 on 1/23/24.
//

import SwiftUI

struct SelectClassView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var DM : DataManager
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<People>
    @State private var editMode = EditMode.active
    @State private var showAlert = false
    var groupingMode: String?
    
    var body: some View {
        List {
            Section {
                if groupingMode == "Personality Grouping" {
                    GuideView(labelName: "Guide", imgName: "questionmark.square", text: "Mode 'Temperament' organizes people into groups based on their personality types (NT, NF, SJ, SP).\n\nMode 'Introverts/Extraverts' organizes people into groups based on introversion and extroversion.\n\nTo make this function work properly, don't forget to include personality types when adding people in the 'Manage' view!")
                    
                    
                }
            }
            
            
            Section{
                ForEach(DM.classNames, id: \.self) { x in
                    NavigationLink {
                        SelectPersonView(DM: DM, className: x, groupingMode: groupingMode)
                    } label: {
                        Text(x)
                    }
                    
                }
                
                
            } header: {
                if DM.classNames.isEmpty {
                    
                    Text("You currently do not have any classes nor people added. Please add a new class and then start to add people.")
                    
                    
                }else {
                    Text("Select a Class")
                }
            }
        }
        .onAppear(perform: {
            if DM.classNames.isEmpty {
                showAlert.toggle()
            }
        })
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text("No classes can be found"),
                  message: Text("Please go to 'Manage Classes' to add a new class and people within."),
                  dismissButton: .cancel(Text("Okay")) {
                presentationMode.wrappedValue.dismiss()
            })
            
        }

        
        
        .navigationTitle(groupingMode ?? "#ERROR")
        
    }
}

#Preview {
    SelectClassView(DM: DataManager(), groupingMode: "Personality Grouping")
}

struct GuideView: View {
    var labelName: String
    var imgName: String
    var text: String
    var disallowHide: Bool?
    @AppStorage("hideGuide1") private var hide: Bool = false
    
    
    var body: some View {
        VStack {
            
            HStack{
                Label(labelName, systemImage: imgName)
                
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(UIColor.systemGray))
                if !(disallowHide ?? false){
                    Button {
                        
                        hide.toggle()
                        
                        
                    } label: {
                        
                        Text(hide ? "Show" : "Hide")
                    }
                
                }
                
            }
            if !hide || (disallowHide ?? false) {
                Text(text)
                    .font(.callout)
                
               
            }
        } .padding(.all)
        
            .background(
                Rectangle()
                
                
                    .foregroundStyle(Color(UIColor.systemGray5))
                
                
                
            )
            .listRowInsets(EdgeInsets())
    }
}
