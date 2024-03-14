//
//  WelcomeSheetView.swift
//  Grouper 2
//
//  Created by 王首之 on 2/25/24.
//

import SwiftUI
import CoreData
import ConfettiSwiftUI

struct WelcomeSheetView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @State private var turnPage: Bool = false
    @ObservedObject var DM : DataManager
    @Environment(\.dismiss) var dismiss
    
    
    
    var body: some View {
        VStack{
            if !turnPage {
                page0
                    .tag(0)
                    .toolbar(.hidden, for: .tabBar)
                    .transition(.backslide)
            } else {
                page1
                
                    .tag(1)
                    .toolbar(.hidden, for: .tabBar)
                    
                
            }
        }
        .interactiveDismissDisabled()
    }
    
    var page1: some View{
        VStack{
            Image("getStarted")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 50)
                .padding(.all)
            Text("Let's \nGet Started!")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .font(.largeTitle)
                .bold()
            
            Button{
                
                DM.classNames = []
                
                DM.classNames.append("Example Class")
                
                let personNames = ["Alice", "Bob", "Charlie", "David", "Eve", "Fiona", "George", "Henry", "Isabella", "Jack", "Kelly", "Liam", "Mia", "Noah", "Olivia"]
                let mbtiTypes = ["INTJ", "INTP", "INFJ", "INFP", "ENTP", "ENFJ", "ENFP", "ESTJ"]

                for x in 0..<15 {
                  let student = People(context: managedObjContext)
                  student.myId = UUID()
                  student.name = personNames[x]
                  student.category = "Example Class"
                  student.type = "Student"
                  student.personality = mbtiTypes.randomElement()!
                    do {
                        try managedObjContext.save()
                        
                    } catch {
                        print("FAILED to save the data")
                    }
                }
                
                dismiss()
                
            } label: {
                Label("Explore with a demo class", systemImage: "greetingcard")
            }
            .font(.title2)
            .foregroundColor(.accentColor)
            .padding(.all)
            .frame(maxWidth: .infinity)
            
            .background(Color.accentColor.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding(.horizontal)
            
            
            Button{
                dismiss()
                
                
            } label: {
                Label("Create my own class later", systemImage: "square.badge.plus")
            }
            .font(.title2)
            .foregroundColor(.accentColor)
            .padding(.all)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding(.horizontal)
                
            
            Spacer()
        }
    }
    
  
    
    
    var page0: some View {
        VStack{
            VStack{
                
                
                Image("logo_V1")
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                
                
                Group{
                    Text("Welcome to ") +
                    Text("Grouper!").foregroundColor(.accentColor)
                }.font(.largeTitle)
                    .bold()
            }
            .padding(.top, 50)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .center) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .frame(width: 35, height: 35)
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .padding()
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Fast grouping using AI")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Introducing machine learning powered group creation: Capture or select a photo, and get your groups formed instantly.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                    }
                    .padding(.top, 40)
                    
                    HStack(alignment: .center) {
                        Image(systemName: "person.2")
                            .frame(width: 35, height: 35)
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .padding()
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Personality grouping")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Find the perfect mix: Create groups with diverse personality traits or communication styles, fostering a balanced and productive environment")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    HStack(alignment: .center) {
                        Image(systemName: "trophy")
                            .frame(width: 35, height: 35)
                            .font(.largeTitle)
                            .foregroundColor(.pink)
                            .padding()
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Group games")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Collaborate and compete: Work together as a group and track your progress towards victory with points.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                }
                .padding(.horizontal, 30)
                .padding(.trailing, 10)
            }
            Spacer()
            
            VStack {
                
                
                Button{
                    withAnimation{
                        turnPage.toggle()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Continue")
                            .font(.headline)
                            .padding(10)
                        Spacer()
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                
            }
            .padding([.horizontal, .bottom], 35)
            
        }
    }
}

#Preview {
    WelcomeSheetView(DM: DataManager())
    
    
}





/// Reference: https://stackoverflow.com/questions/69663197/how-can-i-reverse-the-slide-transition-for-a-swiftui-animation
/// Reverses the slide transition after pressing the "continue" button
extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}
