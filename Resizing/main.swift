//
//  main.swift
//  Resizing
//
//  Created by michal on 09/04/2018.
//  Copyright © 2018 borama. All rights reserved.
//

import Foundation

// open file
let args = CommandLine.arguments
let numOfArguments = args.count

guard numOfArguments > 1 else {
    print("need to provide path")
    exit(1)
}

let ioUtils = IOUtils()

let imageProcessor = ImageProcessor()

let path = CommandLine.arguments

let imgString = "/Users/michal/vectortv.jpg"
guard let image = ioUtils.openFile(path: imgString) else {
    print("can't open image")
    exit(1)
}

imageProcessor.resizeToAll(image, formats: imageProcessor.sizes, completionHandler: {image, width in
    print(width)
    ioUtils.save(image, path: imgString, size: width)
})



