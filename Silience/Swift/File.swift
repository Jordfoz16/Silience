//
//  File.swift
//  Silience
//
//  Created by Jordan Foster on 21/02/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import Foundation

class File {
    
    private var isCreated: Bool = false
    
    //Gets the Documents URL
    var DocumentDirURL: URL{
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url
    }
    
    //Gets the files URL
    func fileURL(fileName: String, fileExtension: String)-> URL{
        return DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    }
    
    //Writes a file to the drive
    func writeFile(writeString: String, fileName: String, fileExtension: String = "txt") {
        let url = fileURL(fileName: fileName, fileExtension: fileExtension)
        do{
            try writeString.write(to: url, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            print ("Failed writing to URL: \(fileURL), Error:" + error.localizedDescription)
        }
    }
    
    //Reads a file and returns the data as a string
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
    
    //Checks to see if a file exists
    func checkFile(fileName: String, fileExtension: String) -> Bool{
        var check = false
        do{
            check = try fileURL(fileName: fileName, fileExtension: fileExtension).checkPromisedItemIsReachable()
        }catch{}
        
        isCreated = check
        return !check
    }
}
