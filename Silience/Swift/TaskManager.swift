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
    
    init(){
        
        //Checks if the file exists, else it will load the file into memory
        if(TaskManager.fileManager.checkFile(fileName: "Task", fileExtension: "json")){
            TaskManager.fileManager.writeFile(writeString: "", fileName: "Task", fileExtension: "json")
        }else{
            let file = TaskManager.fileManager.readFile(fileName: "Task", fileExtension: "json")
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
        
        TaskManager.fileManager.writeFile(writeString: jsonData, fileName: "Task", fileExtension: "json")
    }
    
    func clear(){
        TaskManager.taskArray.removeAll()
        TaskManager.fileManager.writeFile(writeString: "", fileName: "Task", fileExtension: "json")
    }
}
