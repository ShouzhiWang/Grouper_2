//
//  DetectionView.swift
//  Grouper 2
//
//  Created by 王首之 on 11/20/23.
//

import SwiftUI

struct DetectionView: View {
    //@State private var image = UIImage(named: "crowd")!
        ///A picture with multiple faces, solely used for testing
    @State private var image = UIImage()
    @StateObject var faceDetector: DetectFaces
    @State private var showGallery = false
    @State private var showCamera = false
    @State private var currentScale: CGFloat = 1.0
    

    @GestureState private var zoomFactor: CGFloat = 1.0

       

       var magnification: some Gesture {

           return MagnificationGesture()

               .updating($zoomFactor) { value, scale, transaction in

                   withAnimation {

                       scale = value

                   }

               }

               .onChanged { value in

                   withAnimation {

                       currentScale += value

                   }

               }

               .onEnded { value in
                   currentScale = 1.0
                   
                   // do nothing
               }

       }
    
    
    var body: some View {
        VStack {
            if faceDetector.outputImage != nil {
               outputted()
                
            } else if (image.isEmpty){
                List {
                    Section{
                        GuideView(labelName: "Guide", imgName: "questionmark.square", text: "Grouper automatically assigns a group number to each person in the picture you take or select from your photo album. \n\nPlease make sure that faces are visible, otherwise they may not be recognized. Later on you can manually add missing persons, if there's any.", disallowHide: true)
                    }

                    
                    Section{
                        Button("Camera", systemImage: "camera"){
                            showCamera = true
                        }
                        .controlSize(.large)
                        
                        Button("Gallery", systemImage: "photo"){
                            showGallery = true
                        }
                        .controlSize(.large)
                    }
                    
                    Section{
                        
                        Button("Demo", systemImage: "greetingcard"){
                            withAnimation{
                                image = UIImage(named: "crowd")!
                            }
                        }
                        .controlSize(.large)
                    } footer: {
                        Text("This demo demonstrates Grouper's image processing by attaching a built-in image with multiple faces.")
                    }
                    
                }.navigationTitle("Fast Grouping")
                    .navigationBarTitleDisplayMode(.large)
            } else {
                Image(systemName: "person.crop.circle.badge.questionmark")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                Text("OK?")
                    .font(.largeTitle)
                    .bold()
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(zoomFactor * currentScale)
                    .gesture(magnification)
                
                Button("Process Image", systemImage: "person.crop.circle.badge.checkmark"){
                    withAnimation {
                    faceDetector.imageArray = []
                    faceDetector.image = image
                    
                        faceDetector.detectFaces(in: image)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top)
                
                Spacer()
        }
            
            
            
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $faceDetector.showErrorAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(faceDetector.errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
        
        .sheet(isPresented: $showGallery) {
                        // Pick an image from the photo library:
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                .ignoresSafeArea()

                        //  If you wish to take a photo from camera instead:
                        // ImagePicker(sourceType: .camera, selectedImage: self.$image)
                }
        .sheet(isPresented: $showCamera) {
            // Pick an image from the photo library:
            //ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            
            //  If you wish to take a photo from camera instead:
            //withAnimation {
                ImagePicker(sourceType: .camera, selectedImage: self.$image)
                .edgesIgnoringSafeArea(.all)
 
        }
        

    }
    
    @ViewBuilder
    func outputted() -> some View {
        
        Image(uiImage: faceDetector.outputImage!)
            .resizable()
            .scaledToFit()
        ScrollView {
            Text("# People: \(faceDetector.imageArray.count)")
            LazyVGrid(columns: [GridItem(.adaptive(minimum:100))]) {
                ForEach(faceDetector.imageArray, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
        VStack{
            Divider()
            if (faceDetector.imageArray.count < 3) {
                Text("You do not have enough people to make groups")
            } else {
                Stepper("Make \(faceDetector.numberOfGroups) Groups", value: $faceDetector.numberOfGroups, in: 2...faceDetector.getMaxGroupNum())
                    .padding(.horizontal)
            }
            
            HStack {
                Button{
                    withAnimation{
                        faceDetector.outputImage = nil
                        image = UIImage()
                    }
                    
                } label: {
                    Image(systemName: "trash")
                        .frame(height: 15)
                }.buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .clipShape(Circle())
                    .tint(.red)
                
                    .padding(.leading)
                
                
                
                Spacer()
                
                NavigationLink {
                    CropView(image: faceDetector.outputImage, faceDetector: faceDetector)
                    
                } label: {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .frame(height: 15)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .clipShape(Circle())
                .tint(.green)
                Spacer()
                
                
                
                NavigationLink {
                    GroupedView(faceDetector: faceDetector)
                    
                } label: {
                    Image(systemName: "arrow.forward")
                        .frame(height: 15)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .clipShape(Circle())
                .padding(.trailing)
                .disabled(faceDetector.imageArray.count < 3)
                
                
                
                

            }
            
        }
        .background(Color(.systemGroupedBackground))

        
    }
}

#Preview {
    DetectionView(faceDetector: DetectFaces())
}
