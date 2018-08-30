//
//  ImageProcessor.swift
//  Resizing
//
//  Created by michal on 09/04/2018.
//  Copyright © 2018 borama. All rights reserved.
//

import Foundation

struct ImageProcessor {
    
    let sizes = [20, 29, 40, 60, 58, 76, 80, 87, 120, 152, 167, 180, 512]
    
    func resizeToAllSizes(_ image: CGImage, sizes: [Int], resizedHandler: @escaping (_ image: CGImage, _ width: Int)->Void, completionHandler: @escaping ()->Void) {

        let dispatchQueue = DispatchQueue(label: "taskQueue", qos: .userInitiated, attributes: .concurrent)
        dispatchQueue.async {
            for size in sizes {
                guard let resized = self.resize(image, outputWidth: size) else {
                    fatalError("can't resize image")
                }
                resizedHandler(resized, size)
            }
            completionHandler()
        }
    }
    
    func resize(_ image: CGImage, outputWidth: Int)-> CGImage? {
        
        print("resizing", outputWidth)
        let width = image.width
        let height = image.height
        
        let scale = Double(outputWidth) / Double(width)
        
        let newHeight = Int(scale * Double(height))
        
        let bytesPerRow = outputWidth * 4 // 4 bytes RGBA per pixel
        let bitsPerComponent = image.bitsPerComponent
        let space = CGColorSpaceCreateDeviceRGB()
        let alpha = CGImageAlphaInfo.premultipliedLast // important because .last doesn't work!!!
        
        guard let context = CGContext(data: nil, width: outputWidth, height: newHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: space, bitmapInfo: alpha.rawValue) else { return nil }
        
        context.interpolationQuality = .high
        context.draw(image, in: CGRect.init(x: 0, y: 0, width: CGFloat(outputWidth), height: CGFloat(newHeight)))
        
        let scaledImage = context.makeImage()
        
        print("resized", outputWidth)
        return scaledImage
    }
}
