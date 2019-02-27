//
//  FirstViewController.swift
//  Silience
//
//  Created by Jordan Foster on 19/02/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Weekly Staff Meeting"
        content.body = "Every Tuesday at 2pm"
        
        let fileManager = File()
        
        print(fileManager.checkFile(fileName: "Tasks", fileExtension: "json"))
        
        if(fileManager.checkFile(fileName: "Tasks", fileExtension: "json")){
            fileManager.writeFile(writeString: "", fileName: "Tasks", fileExtension: "json")
            print("File Created")
        }
    }
    
    @IBAction func decodeJSON(_ sender: Any) {
        let jsonParser = ParseJSON()
        let fileManager = File()
        
        jsonParser.decodeJSON(jsonString: fileManager.readFile(fileName: "Tasks", fileExtension: "json"))
        
        for i in jsonParser.arrayJSON{
            print(i.name)
        }
    }
}
