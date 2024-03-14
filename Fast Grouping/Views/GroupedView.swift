//
//  GroupedView.swift
//  
//
//  Created by 王首之 on 12/1/23.
//

import SwiftUI

struct GroupedView: View {
    @StateObject var faceDetector: DetectFaces
    //@State var numberOfGroups: Int
    
    var body: some View {
        ScrollView {
            //Text("# People: \(faceDetector.imageArray.count)")
            //Text("Hello")
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum:100))]) {
                ForEach(0..<faceDetector.randomizedArray.endIndex, id: \.self) { imageIndex in
                    
                        
                    
                    SingleGroup(faceDetector: faceDetector, imageIndex: imageIndex)
                        
                    }
                    
                    
                    
                    
               
                
            }        
            
//            .background {
//                ZStack(alignment: .top) {
//                    Rectangle()
//                        .opacity(0.3)
//                    
//                }
//                .foregroundColor(.teal)
//            }
//            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
//            .padding(.all)
//            

        }
        .onAppear {
            faceDetector.getShuffledList()
        }
        Button{
            faceDetector.getShuffledList()
        } label: {
            (Text(Image(systemName: "shuffle.circle")) + Text(" Shuffle"))
                .frame(minWidth: 0, maxWidth: .infinity)
            
        }
        
        .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.all)
            
    }
}

#Preview {
    GroupedView(faceDetector: DetectFaces())
}

struct SingleGroup: View {
    @StateObject var faceDetector: DetectFaces
    var imageIndex: Int
    
    var body: some View {
        Section(header: Text("Group \(imageIndex+1)").font(.title).bold()) {
            
            ForEach(faceDetector.randomizedArray[imageIndex], id: \.self) { image in
                LazyVGrid(columns: [GridItem(.adaptive(minimum:100))]) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    
                }
                
                
            }
            
        }
        
        
    }
}
