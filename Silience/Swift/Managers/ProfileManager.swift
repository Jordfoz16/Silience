//
//  ProfileManager.swift
//  Silience
//
//  Created by Jordan Foster on 15/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import Foundation

struct User: Codable {
    let firstName: String
    let secondName: String
    let bio: String
    let pictureID: String
}

class ProfileManager{
    
    static let fileManager = File()
    static let jsonParser = ParseJSON()
    
    static var profile = [User]()
    
    let fileName = "Profile"
    let fileExtension = "json"
    
    init(){
        if(ProfileManager.profile.isEmpty){
            //Checks if the file exists, else it will load the file into memory
            if(ProjectManager.fileManager.checkFile(fileName: fileName, fileExtension: fileExtension)){
                ProfileManager.fileManager.writeFile(writeString: "", fileName: fileName, fileExtension: fileExtension)
            }else{
                let file = ProfileManager.fileManager.readFile(fileName: fileName, fileExtension: fileExtension)
                if(!file.isEmpty){
                    ProfileManager.profile = ProfileManager.jsonParser.decodeJSON(jsonString: file) as! [User]
                }
            }
        }
    }
    
    func profileCreated() -> Bool{
        var profileExists = false
        
        if(ProfileManager.profile.count != 0){
            profileExists = true
        }
        
        return profileExists
    }
    
    func updateProfile(profileUpdate: User){
        if(ProfileManager.profile.count == 0){
            ProfileManager.profile.append(profileUpdate)
        }else{
            ProfileManager.profile[0] = (profileUpdate)
        }
        
        save()
    }

    func save(){
        let jsonData = ProfileManager.jsonParser.encodeJSON(data: ProfileManager.profile)

        ProfileManager.fileManager.writeFile(writeString: jsonData, fileName: fileName, fileExtension: fileExtension)
    }
    
    func getUser() -> User {
        
        return ProfileManager.profile[0]
    }
}
