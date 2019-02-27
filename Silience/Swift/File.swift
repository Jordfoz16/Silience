//
//  File.swift
//  Silience
//
//  Created by Jordan Foster on 21/02/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import Foundation

class File {
    
    /*
        File Management for creating and read files
    */
    
    private var isCreated: Bool = false
    
    var DocumentDirURL: URL{
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url
    }
    
    func fileURL(fileName: String, fileExtension: String)-> URL{
        return DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    }
    
    func writeFile(writeString: String, fileName: String, fileExtension: String = "txt") {
        
        let url = fileURL(fileName: fileName, fileExtension: fileExtension)
        do{
            try writeString.write(to: url, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            print ("Failed writing to URL: \(fileURL), Error:" + error.localizedDescription)
        }
    }
    
    func readFile(fileName: String, fileExtension: String = "txt") -> String {
        var readString = ""
        let url = fileURL(fileName: fileName, fileExtension: fileExtension)
        do{
            readString = try String(contentsOf: url)
        } catch let error as NSError {
            print ("Failed writing to URL: \(fileURL), Error:" + error.localizedDescription)
        }
        return readString
    }
    
    func checkFile(fileName: String, fileExtension: String = "txt") -> Bool{
        let check = fileURL(fileName: fileName, fileExtension: fileExtension).isFileURL
        isCreated = check
        return check
    }
}
