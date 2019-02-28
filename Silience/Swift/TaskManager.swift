//
//  Task.swift
//  Silience
//
//  Created by Jordan Foster on 26/02/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import Foundation

struct Task: Codable {
    let name: String
    let startDate: String
    let endDate: String
    let hours: String
    let description: String
}

class TaskManager {
    static let fileManager = File()
    static let jsonParser = ParseJSON()
    
    static var taskArray = [Task]()
    
    let fileName = "Task"
    let fileExtension = "json"
    
    init(){
        
        //Checks if the file exists, else it will load the file into memory
        if(TaskManager.fileManager.checkFile(fileName: fileName, fileExtension: fileExtension)){
            TaskManager.fileManager.writeFile(writeString: "", fileName: fileName, fileExtension: fileExtension)
        }else{
            let file = TaskManager.fileManager.readFile(fileName: fileName, fileExtension: fileExtension)
            if(!file.isEmpty){
                TaskManager.taskArray = TaskManager.jsonParser.decodeJSON(jsonString: file) as! [Task]
            }
        }
    }
    
    func add(task: Task){
        TaskManager.taskArray.append(task)
    }
    
    func remove(){
        
    }
    
    func save(){
        let jsonData = TaskManager.jsonParser.encodeJSON(data: TaskManager.taskArray)
        
        TaskManager.fileManager.writeFile(writeString: jsonData, fileName: fileName, fileExtension: fileExtension)
    }
    
    func clear(){
        TaskManager.taskArray.removeAll()
        TaskManager.fileManager.writeFile(writeString: "", fileName: fileName, fileExtension: fileExtension)
    }
}
