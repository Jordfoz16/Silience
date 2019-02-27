//
//  JSON.swift
//  Silience
//
//  Created by Jordan Foster on 22/02/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import Foundation

class ParseJSON {
    
    /*
     Redo:
     
     Encoding
     Decoding
     Adding Task
     
     Tasks Needs Bool Finished
     Description
     */
    
    private var encodedData: Data = Data()
    
    public var arrayJSON = [Task] ()
    
    func addTask(task: Task){
        let fileManager = File()
        
        decodeJSON(jsonString: fileManager.readFile(fileName: "Tasks", fileExtension: "json"))
        
        arrayJSON.append(task)
    }
    
    func encodeJSON(){
        let encoder = JSONEncoder()
        
        do{
            encodedData = try encoder.encode(arrayJSON)
            print("JSON Encoded")
        } catch let error{
            print(error as Any)
        }
    }
    
    func decodeJSON(jsonString: String){
        //Converts a json string into an array of tasks
        let jsonData = jsonString.data(using: .utf8)!
        decodeJSON(jsonData: jsonData)
    }
    
    func decodeJSON(jsonData: Data){
        //Converts a json data into an array of tasks
        let decoder = JSONDecoder()
        
        do{
            arrayJSON = try decoder.decode([Task].self, from: jsonData)
        } catch let error{
            print(error as Any)
        }
    }
    
    func jsonToString() -> String{
        return String(data: encodedData, encoding: .utf8)!
    }
}
