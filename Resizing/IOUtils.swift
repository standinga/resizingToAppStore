//
//  FileOpener.swift
//  Resizing
//
//  Created by michal on 09/04/2018.
//  Copyright © 2018 borama. All rights reserved.
//

import Foundation
import ImageIO

struct IOUtils {
    
    enum FileExtension {
        case jpg, png
    }
    
    func openFile(path: String)->CGImage? {
        print("will openFile path: \(path)")
        let url = URL.init(fileURLWithPath: path)
        guard url.isFileURL else {
            fatalError("not a file")
        }
        let options:Dictionary = [kCGImageSourceShouldCache: "true"]
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, options as CFDictionary) else {
            fatalError("can't create imageSource")
        }
        guard let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            fatalError("can't open image")
        }
        return image
    }
    
    func save(_ image: CGImage, path: String, size: Int) {
        print("will save, path: \(path)")
        guard let (fName, ext) = createFileName(path: path, size: size) else {
            fatalError("can't createFileName from path: \(path) extenssizeion: \(size)" )
        }
        let url = URL.init(fileURLWithPath: fName)
        let type = ext == .jpg ? kUTTypeJPEG : kUTTypePNG
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, type, 1, nil) else {
            fatalError("can't create destination from url: \(url.absoluteString)")
        }
        CGImageDestinationAddImage(destination, image, nil)
        
        let finalized = CGImageDestinationFinalize(destination)
        
        if !finalized {
            fatalError("can't CGImageDestinationFinalize destination: \(destination) ")
        }
    }
    
    func createFileName(path: String, size: Int)-> (name: String, ext: FileExtension)? {
        var splitPath = path.split(separator: "/")
        guard let nameWithExtension = splitPath.popLast() else {
            fatalError("can't get file name")
        }
        
        var path = ""
        let length = splitPath.count
        if length > 1 {
            path = splitPath.reduce("", {$0 + "/" + $1})
        }
        
        guard let fName = nameWithExtension.split(separator: ".").first else {
            fatalError("can't get fName")
        }
        guard let extString = nameWithExtension.split(separator: ".").last else {
            fatalError("can't get extension")
        }
        let newFname = "\(path)/\(fName)@\(size).\(extString)"
        let ext = extString == "jpg" ? FileExtension.jpg : .png
        return (name: newFname, ext: ext)
    }
}
