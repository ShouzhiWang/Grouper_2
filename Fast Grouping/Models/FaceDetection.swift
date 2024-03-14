//
//  FaceDetection.swift
//  Grouper 2
//
//  Created by 王首之 on 11/19/23.
//
/// Reference: https://www.youtube.com/watch?v=qzqAvgR4d2c

import Foundation
import SwiftUI
import Vision

class DetectFaces: ObservableObject {
    var image: UIImage = UIImage()
    @Published var outputImage : UIImage?
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    private var detectedFaces : [VNFaceObservation] = [VNFaceObservation()]
    @Published var imageArray: [UIImage] = []
    @Published var randomizedArray : [[UIImage]] = []
    @Published var numberOfGroups = 2
    
    func detectFaces(in image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            fatalError("Couldn't convert image to CIImage")
        }
        let request = VNDetectFaceRectanglesRequest(completionHandler: self.handleFacesData)
        
        #if targetEnvironment(simulator)
        request.usesCPUOnly = true
        #endif
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
        } catch let reqError {
            print ("Failed to perform request:", reqError)
            showError(message: "Failed to perform request: \(reqError)")
        }
    }
    
    func handleFacesData(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results as? [VNFaceObservation] else {
                self.showError(message: "Error processing face detection results")
                return
            }
            self.detectedFaces = results  
            if self.detectedFaces == []
            {
                self.showError(message: "Sorry, we couldn't find any faces. Please try to take another picture or manually add faces.")
            }
            for faces in self.detectedFaces {
                self.addFaceRectToImage(result: faces)
            }
            self.outputImage = self.image
            
        }
    }
    
    private func showError(message: String) {
            errorMessage = message
            showErrorAlert = true
        }
    
    func addFaceRectToImage(result: VNFaceObservation) {
        let imageSize = CGSize(width: image.size.width, height: image.size.height)
        
        let boundingBox = result.boundingBox
        let scaledBox = CGRect(
            x: boundingBox.origin.x * imageSize.width,
            y: (1-boundingBox.origin.y - boundingBox.size.height)*imageSize.height,
            width: boundingBox.size.width * imageSize.width,
            height: boundingBox.size.height * imageSize.height
        )
        
        let normalizedRect = VNNormalizedRectForImageRect(scaledBox, Int(imageSize.width), Int(imageSize.height))
        
        imageArray.append(cropImage1(image: image, rect: CGRect(x: normalizedRect.origin.x * imageSize.width, y: normalizedRect.origin.y * imageSize.height, width:  normalizedRect.size.width * imageSize.width, height: normalizedRect.size.height * imageSize.height)))
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: .zero)
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(5.0)
        context.stroke(CGRect(x: normalizedRect.origin.x * imageSize.width, y: normalizedRect.origin.y * imageSize.height, width:  normalizedRect.size.width * imageSize.width, height: normalizedRect.size.height * imageSize.height))
        
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
    
    
    func cropImage1(image: UIImage, rect: CGRect) -> UIImage {
        guard let cgImage = image.cgImage else {
            fatalError("Couldn't crop image")
        }
        let croppedCGImage = cgImage.cropping(to: rect)
        return UIImage(cgImage: croppedCGImage!)
    }
    
    func getMaxGroupNum () -> Int {
        if imageArray.count < 4 {
            return 3
        } else {
            return imageArray.count - 1
        }
    }
    
    func getShuffledList(){
        var storage = [[UIImage]]()
        
        
        if !imageArray.isEmpty {
            var tempImgArray = imageArray
            tempImgArray.shuffle()
            
            let numberPerGroup = tempImgArray.count / numberOfGroups
            var tempInnerList = [UIImage]()
            var sequence = 0
            for _ in 1...numberOfGroups {
                
                for _ in 1...numberPerGroup {
                    tempInnerList.append(tempImgArray[sequence])
                    
                    sequence += 1
                }
                storage.append(tempInnerList)
                tempInnerList.removeAll()
            }
            
            
            if tempImgArray.count != sequence {
                for x in 0...storage.count-1 {
                    storage[x].append(tempImgArray[sequence])
                    sequence += 1
                    if tempImgArray.count == sequence {
                        break
                    }
                }
                
            }

        }
        randomizedArray = storage
    }
}

