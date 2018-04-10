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

guard let image = ioUtils.openFile(path: args[1]) else {
    print("can't open image")
    exit(1)
}

imageProcessor.resizeToAll(image, formats: imageProcessor.sizes, completionHandler: {image, width in
    ioUtils.save(image, path: args[1], size: width)
})

dispatchMain() //prevents exitting app before finishing async task



