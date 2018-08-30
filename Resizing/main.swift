//
//  main.swift
//  Resizing
//
//  Created by michal on 09/04/2018.
//  Copyright © 2018 borama. All rights reserved.
//

import Foundation

// open file first argument should be path to file, second (optional) will be output base name
let args = CommandLine.arguments
let numOfArguments = args.count
print(args)
print(numOfArguments)

guard numOfArguments > 1 else {
    print("need to provide path to input file")
    exit(1)
}

let ioUtils = IOUtils()

let inputFileName = CommandLine.arguments[1]
let outputFileName = numOfArguments == 3 ? CommandLine.arguments[2] : inputFileName

let imageProcessor = ImageProcessor()
let fileManager = FileManager.default
let basePath = fileManager.currentDirectoryPath

let fullPath = basePath + "/" + outputFileName

guard let image = ioUtils.openFile(path: inputFileName) else {
    print("can't open image")
    exit(1)
}

imageProcessor.resizeToAllSizes(image, sizes: imageProcessor.sizes, resizedHandler: {image, width in
    ioUtils.save(image, path: fullPath, size: width)
}, completionHandler: {
    print("finished all")
    exit(0)
})

dispatchMain() //prevents exitting app before finishing async task



