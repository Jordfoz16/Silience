//
//  DayWord.swift
//  Silience
//
//  Created by Jordan Foster on 28/02/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import Foundation

class DailyWords{
    
    static let fileManager = File()
    static let jsonParser = ParseJSON()
    
    static var wordsArray = [String]()
    
    let fileName = "Words"
    let fileExtension = "json"
    
    let defaultWords = ["Nature", "City", "Waterfall", "Fish", "Plants", "Ink", "Clouds"]
    
    init(){
        
        //Checks if the file exists, else it will load the file into memory
        if(TaskManager.fileManager.checkFile(fileName: fileName, fileExtension: fileExtension)){
            TaskManager.fileManager.writeFile(writeString: "", fileName: fileName, fileExtension: fileExtension)
            loadDefault()
        }else{
            let file = TaskManager.fileManager.readFile(fileName: fileName, fileExtension: fileExtension)
            if(!file.isEmpty){
                DailyWords.wordsArray = DailyWords.jsonParser.decodeJSON(jsonString: file) as! [String]
            }else{
                loadDefault()
            }
        }
    }
    
    func loadDefault(){
        for word in defaultWords{
            add(word: word)
        }
    }
    
    func getRandomWord() -> String{
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        let string = formatter.string(from: currentDateTime)
        let unicodeScalars = string.unicodeScalars.map { Int($0.value) }
        let unicodeHash = unicodeScalars.reduce(0, +) % defaultWords.count
        
        return defaultWords[unicodeHash]
    }
    
    func add(word: String){
        DailyWords.wordsArray.append(word)
    }
    
    func save(){
        let jsonData = DailyWords.jsonParser.encodeJSON(data: DailyWords.wordsArray)
        
        DailyWords.fileManager.writeFile(writeString: jsonData, fileName: fileName, fileExtension: fileExtension)
    }
    
    func clear(){
        DailyWords.wordsArray.removeAll()
        DailyWords.fileManager.writeFile(writeString: "", fileName: fileName, fileExtension: fileExtension)
    }
}
