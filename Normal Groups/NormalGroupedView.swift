//
//  NormalGroupedView.swift
//
//
//  Created by 王首之 on 1/24/24.
//

import SwiftUI

struct NormalGroupedView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var DM : DataManager
    var groupingMode: String?
    var selectedType: Int?
    
    var gridView: some View {
        ScrollView {
            Spacer(minLength: 50)
            LazyVGrid(columns: [GridItem(.adaptive(minimum:150), alignment: .top)]) {
                ForEach(0..<DM.randomizedArray.endIndex, id: \.self) { index in
                    VStack{
                        Text("Group \(index+1)").font(.title2).bold()
                        ForEach(DM.randomizedArray[index], id: \.self) { people in
                            
                            Text(people.name)
                                .frame(maxWidth: .infinity)
                            
                            
                            
                        }
                        
                    }.padding(.all)
                        
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.random())
                        )
                        
                    

                    
                }
                
            }.padding(.horizontal)
                
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
                            withAnimation {
                                if groupingMode == "Personality Grouping" {
                                    if selectedType == 0 {
                                        DM.getPersonalityGroupsShuffled()
                                    } else if selectedType == 1 {
                                        DM.getPersonalityIEShuffled()
                                    }
                                    
                                } else {
                                    DM.getShuffled()
                                }
                            }
                        } label: {
                            (Text(Image(systemName: "shuffle.circle")) + Text(" Shuffle"))
                                .frame(minWidth: 0, maxWidth: .infinity)
                            
                        }
                        
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .padding(.trailing)
                        
                        
                        
                        
                    }.padding(.bottom)
                }
            }
            
            
        }
    }
    
}

/// Generating a random color
/// Reference: https://danielsaidi.com/blog/2022/05/25/generating-a-random-color


public extension Color {
    static func random(randomOpacity: Bool = false) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 0.3
        )
    }
}

/// Save a view to the user's photo album.
/// Reference: https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}


#Preview {
    NormalGroupedView(DM: DataManager())
}
