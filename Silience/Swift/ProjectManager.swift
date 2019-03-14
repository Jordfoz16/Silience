//
//  Task.swift
//  Silience
//
//  Created by Jordan Foster on 26/02/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import Foundation

enum ProjectType: String, Codable {
    case daily
    case project
}

struct Projects: Codable {
    let name: String
    let startDate: String
    let endDate: String
    let hours: String
    let description: String
    let projectType: ProjectType
    let projectComplete: Bool
}

class ProjectManager {
    static let fileManager = File()
    static let jsonParser = ParseJSON()
    
    static var projectsArray = [Projects]()
    
    let fileName = "Task"
    let fileExtension = "json"
    
    init(){
        
        //Checks if the file exists, else it will load the file into memory
        if(ProjectManager.fileManager.checkFile(fileName: fileName, fileExtension: fileExtension)){
            ProjectManager.fileManager.writeFile(writeString: "", fileName: fileName, fileExtension: fileExtension)
        }else{
            let file = ProjectManager.fileManager.readFile(fileName: fileName, fileExtension: fileExtension)
            if(!file.isEmpty){
                ProjectManager.projectsArray = ProjectManager.jsonParser.decodeJSON(jsonString: file) as! [Projects]
            }
        }
    }
    
    func add(task: Projects){
        ProjectManager.projectsArray.append(task)
    }
    
    func remove(){
        
    }
    
    func save(){
        let jsonData = ProjectManager.jsonParser.encodeJSON(data: ProjectManager.projectsArray)
        
        ProjectManager.fileManager.writeFile(writeString: jsonData, fileName: fileName, fileExtension: fileExtension)
    }
    
    func clear(){
        ProjectManager.projectsArray.removeAll()
        ProjectManager.fileManager.writeFile(writeString: "", fileName: fileName, fileExtension: fileExtension)
    }
    
    func isEvent(date: String) -> Bool {
        
        for project in ProjectManager.projectsArray {
            if(project.startDate == date){
                return true
            }
        }
        
        return false
    }
    
    func filterByDate(date: String) -> [Projects]{
        //Date format dd/MM/yyyy
        
        var filteredProject = [Projects]()
        
        for project in ProjectManager.projectsArray {
            
            if(project.startDate == date){
                filteredProject.append(project)
            }
        }
        
        return filteredProject
    }
}
