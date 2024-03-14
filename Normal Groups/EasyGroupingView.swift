//
//  EasyGroupingView.swift
//  Grouper 2
//
//  Created by 王首之 on 2/5/24.
//

import SwiftUI

struct EasyGroupingView: View {
    @FocusState private var keyboardFocused: Bool
    @State private var profileText = "Enter names, one per line"
    @State private var placeholderString = "Enter names, one per line"
    @State private var numGroups: Int = 2
    @State private var sheetUp = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var DM : DataManager
    
    var body: some View {
        NavigationStack {
            List {
                TextEditor(text: $profileText)
                    .foregroundColor(self.profileText == placeholderString ? .gray : .primary)
                    .focused($keyboardFocused)
                    .onTapGesture {
                    if self.profileText == placeholderString {
                        withAnimation{
                            self.profileText = ""
                        }
                    }
                  }
                    
                    
            }
            .navigationTitle("Easy Grouping")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                            // the Spacer will push the Done button to the far right of the keyboard as pictured.
                            Spacer()
                            
                            Button(action: {
                                keyboardFocused = false
                            }, label: {
                                Text("Done")
                            })
                            
                        }
                ToolbarItem(placement: .bottomBar) {
                    
                    
                    
                    HStack {
                        if (profileText.split(whereSeparator: \.isNewline).count < 3) {
                            Text("You do not have enough people to make groups")
                                .padding(.horizontal)
                        } else {
                            Stepper("Make \(numGroups) Groups", value: $numGroups, in: 2...getMaxGroupNum())
                                .padding(.horizontal)
                        }
                        
                        
                        Spacer()
                        
                        
                        
                        Button {
                   
                            DM.easyGroupInit(input: profileText.split(whereSeparator: \.isNewline).map(String.init), numberOfGroups: numGroups)
                         
                            sheetUp.toggle()
                            
                        } label: {
                            Image(systemName: "arrow.forward")
                                .frame(height: 15)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .clipShape(Circle())
                        .padding(.trailing)
                        
                        .disabled(profileText.split(whereSeparator: \.isNewline).count < 3)
                        
                        
                        
                        
                        
                    }
                    
                    
                }
            }
            .sheet(isPresented: $sheetUp) {
                EasyGroupedView(DM: DM)
            }
        }
    }
    
    func getMaxGroupNum () -> Int {
        if profileText.split(whereSeparator: \.isNewline).count < 4 {
            return 3
        } else {
            return profileText.split(whereSeparator: \.isNewline).count - 1
        }
    }
}

#Preview {
    EasyGroupingView(DM: DataManager())
}
