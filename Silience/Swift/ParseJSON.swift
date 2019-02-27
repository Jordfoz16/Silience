//
//  JSON.swift
//  Silience
//
//  Created by Jordan Foster on 22/02/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import Foundation

class ParseJSON {
    
    //Encodes the array into JSON format
    func encodeJSON(data: [Task]) -> String{
        let encoder = JSONEncoder()
        var encodedData: Data = Data()
        
        do{
            encodedData = try encoder.encode(data)
        } catch let error{
            print(error as Any)
        }
        
        return String(data: encodedData, encoding: .utf8)!
    }
    
    //Decodes a JSON formatted string into an array
    func decodeJSON(jsonString: String) -> Any{
        //Converts a json string into an array of tasks
        let jsonData = jsonString.data(using: .utf8)!
        return decodeJSON(jsonData: jsonData)
    }
    
    //Decodes JSON formatted data into an array
    func decodeJSON(jsonData: Data) -> Any{
        let decoder = JSONDecoder()
        var data = [Any]()
        
        do{
            //Put the data into an array of tasks
            data = try decoder.decode([Task].self, from: jsonData)
        } catch let error{
            print(error as Any)
        }
        
        return data
    }
}
