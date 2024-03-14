//
//  SwiftUIView.swift
//  
//
//  Created by 王首之 on 2/5/24.
//

import SwiftUI

struct EasyGroupedView: View {
    
        
        @Environment(\.presentationMode) var presentationMode
        @ObservedObject var DM : DataManager
        
        var gridView: some View {
            ScrollView {
                Spacer(minLength: 50)
                LazyVGrid(columns: [GridItem(.adaptive(minimum:150), alignment: .top)]) {
                    ForEach(0..<DM.randomizedStringArray.endIndex, id: \.self) { index in
                        VStack{
                            Text("Group \(index+1)").font(.title2).bold()
                            ForEach(DM.randomizedStringArray[index], id: \.self) { people in
                                
                                Text(people)
                                    .frame(maxWidth: .infinity)
                                
                                
                                
                            }
                            
                        }.padding(.all)
                            
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.random())
                            )
                            
                        

                        
                    }
                    
                }.padding(.horizontal)
                    //.shadow(radius: 8)
            }
            .edgesIgnoringSafeArea(.all)
        }
        
        var body: some View {
            NavigationStack{
                gridView
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Done")
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        HStack{
                            
                            Button{
                                let image = gridView.snapshot()
                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                
                                    DM.albumSaved = true
                                
                            } label: {
                                (Text(Image(systemName: DM.albumSaved ? "checkmark.seal.fill" : "arrow.down.app")) + Text(DM.albumSaved ? " Saved" :" Save"))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .padding(.leading)
                            .tint(.secondary)
                            .disabled(DM.albumSaved)
                            
                            
                            Button{
                                DM.getEasyGroupsShuffled()
                            } label: {
                                (Text(Image(systemName: "shuffle.circle")) + Text(" Shuffle"))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                
                            }
                            
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .padding(.trailing)
                            
                            
                            
                            
                        }
                    }
                }
                
                
            }
        }
        
    
}

#Preview {
    EasyGroupedView(DM: DataManager())
}
