//
//  FileOpener.swift
//  Resizing
//
//  Created by michal on 09/04/2018.
//  Copyright © 2018 borama. All rights reserved.
//

import Foundation

class IOUtils {
    
    enum FileExtension {
        case jpg, png
    }
    
    func openFile(path: String)->CGImage? {
        let url = URL.init(fileURLWithPath: path)
        guard url.isFileURL else {
            print("not a file")
            return nil
        }
        let options:Dictionary = [kCGImageSourceShouldCache: "true"]
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, options as CFDictionary) else {
            print("can't create imageSource")
            return nil
        }
        guard let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            print("can't open image")
            return nil
        }
        return image
    }
    
    func save(_ image: CGImage, path: String, size: Int) {
        guard let (fName, ext) = createFileName(path: path, size: size) else {
            print(#line)
            return
        }
        let url = URL.init(fileURLWithPath: fName)
        let type = ext == .jpg ? kUTTypeJPEG : kUTTypePNG
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, type, 1, nil) else {
            print(#line)
            return
        }
        CGImageDestinationAddImage(destination, image, nil)
        
        let finalized = CGImageDestinationFinalize(destination)
        
        if !finalized {
            print(#line)
            return
        }
    }
    
    func createFileName(path: String, size: Int)-> (name: String, ext: FileExtension)? {
        var splitPath = path.split(separator: "/")
        guard let nameWithExtension = splitPath.popLast() else {
            print("can't get file name")
            return nil
        }
        
        var path = ""
        let length = splitPath.count
        if length > 1 {
            path = splitPath.reduce("", {$0 + "/" + $1})
        }
        
        guard let fName = nameWithExtension.split(separator: ".").first else {
            print("can't get fName")
            return nil
        }
        guard let extString = nameWithExtension.split(separator: ".").last else {
            print("can't get extension")
            return nil
        }
        let newFname = "\(path)/\(fName)@\(size).\(extString)"
        let ext = extString == "jpg" ? FileExtension.jpg : .png
        return (name: newFname, ext: ext)
    }
}
