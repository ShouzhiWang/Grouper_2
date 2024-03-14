//
//  CropView.swift
//  Grouper 2
//
//  Created by 王首之 on 11/23/23.
//

/// Reference: https://www.youtube.com/watch?v=1Fz86eQjxus

import SwiftUI
import UIKit

struct CropView: View {
    var image: UIImage?
    //var onCrop: (UIImage?, Bool)->()
    @ObservedObject var faceDetector: DetectFaces
    @Environment (\.dismiss) private var dismiss
    
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    
    var body: some View {
        
            imageView()
                .navigationBarTitleDisplayMode(.inline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .navigationTitle("Crop")
                
            
                .background {
                    Color.black
                        .ignoresSafeArea()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            let renderer = ImageRenderer(content: imageView())
                            
                            renderer.proposedSize = .init(width: 300, height: 300)
                            if let image = renderer.uiImage {
                                faceDetector.imageArray.insert(image, at: 0)
                                
                                }
                                    
                            dismiss()
                        } label: {
                            Image(systemName: "checkmark")
                                .fontWeight(.semibold)
                                .font(.callout)
                        }
                    }
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button {
//                            dismiss()
//                        } label: {
//                            Image(systemName: "xmark")
//                                .fontWeight(.semibold)
//                                .font(.callout)
//                        }
//                    }

            }
        
    }
    @ViewBuilder
    func imageView() -> some View {
        GeometryReader {
            let size = $0.size
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    
                    .overlay(content: {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            
                            Color.clear
                                .onChange(of: isInteracting) { newValue in
                                    
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if rect.minX > 0 {
                                            offset.width = (offset.width - rect.minX)
                                        }
                                        if rect.minY > 0 {
                                            offset.height = (offset.height - rect.minY)
                                        }
                                        if rect.maxX < 300 {
                                            offset.width = (rect.minX - offset.width)
                                            
                                        }
                                        if rect.maxY < 300 {
                                            offset.height = (rect.minY - offset.height)
                                            
                                        }
                                    }
                                    
                                    if !newValue {
                                        lastStoredOffset = offset
                                        
                                    }
                                }
                        }
                        
                    })
                    .frame(size)
                    
                    
                
            }
        }
        
        .scaleEffect(scale)
        .offset(offset)
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width + lastStoredOffset.width,height: translation.height + lastStoredOffset.height)
                })
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    let updatedScale = value + lastScale
                    scale = (updatedScale < 1 ? 1 : updatedScale)
                }).onEnded({ value in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                            
                        } else {
                            lastScale = scale - 1
                        }
                            
                    }
                })
        )
        .frame(width: 300, height: 300)
        .cornerRadius(0)
        
    }
}

#Preview {
    CropView(image: UIImage(named: ("crowd")), faceDetector: DetectFaces()) 
}
