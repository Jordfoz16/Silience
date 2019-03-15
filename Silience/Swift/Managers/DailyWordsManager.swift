//
//  DayWord.swift
//  Silience
//
//  Created by Jordan Foster on 28/02/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import Foundation

class DailyWordsManager{
    
    static let fileManager = File()
    static let jsonParser = ParseJSON()
    
    static var wordsArray = [String]()
    
    let fileName = "Words"
    let fileExtension = "json"
    
    let defaultWords = ["Happy","Love","Hopeless","Animal","Dream","Nightmare","Shadow","Drained","Wow","City","Ink","Plants","Bike","Town","Clothes","Dark","Night","Cold","Warm","Excited","Colourful","Minimalist","Monochrome","Secret","Sky","Fashion","Calm","Imagination","Small","Fluffy","Sad ","Technology","New","Old","Ancient","Weathered","Geometric","Curves","Refined","Attractive","Abstract","Travel ","Work ","Education","Water","Limbo","Lust","Gluttony","Greed","Rage","Heresy","Violence","Fraud","Treachery"]
    
    init(){
        
        //Checks if the file exists, else it will load the file into memory
        if(ProjectManager.fileManager.checkFile(fileName: fileName, fileExtension: fileExtension)){
            ProjectManager.fileManager.writeFile(writeString: "", fileName: fileName, fileExtension: fileExtension)
            loadDefault()
        }else{
            let file = ProjectManager.fileManager.readFile(fileName: fileName, fileExtension: fileExtension)
            
            if(!file.isEmpty){
                DailyWordsManager.wordsArray = DailyWordsManager.jsonParser.decodeJSON(jsonString: file) as! [String]
            }else{
                loadDefault()
            }
        }
    }
    
    func loadDefault(){
        for word in defaultWords{
            add(word: word)
        }
        
        save()
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
        DailyWordsManager.wordsArray.append(word)
        save()
    }
    
    func save(){
        let jsonData = DailyWordsManager.jsonParser.encodeJSON(data: DailyWordsManager.wordsArray)
        
        DailyWordsManager.fileManager.writeFile(writeString: jsonData, fileName: fileName, fileExtension: fileExtension)
    }
    
    func clear(){
        DailyWordsManager.wordsArray.removeAll()
        DailyWordsManager.fileManager.writeFile(writeString: "", fileName: fileName, fileExtension: fileExtension)
    }
}
