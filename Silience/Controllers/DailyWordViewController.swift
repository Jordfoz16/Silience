//
//  FirstViewController.swift
//  Silience
//
//  Created by Jordan Foster on 19/02/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit
import UserNotifications
import Photos
import PhotosUI

class DailyWordViewController: UIViewController {
    
    @IBOutlet weak var dailyWord: UILabel!

    @IBOutlet weak var wordImage: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    
    let taskManager = ProjectManager()
    let dayWord = DailyWordsManager()
    
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
        
        dailyWord.text = dayWord.getRandomWord()
    }
    
    @IBAction func pickImage(_ sender: Any) {
    
    }
    
    @IBAction func saveDaily(_ sender: Any) {
        
        let name = nameText.text! + " - " + dailyWord.text!
        let description = descriptionText.text
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy"
        
        let startDate = formatter.string(from: date)
        
        var hasher = Hasher()
        
        hasher.combine(name)
        hasher.combine(startDate)
        
        let uniqueID = hasher.finalize()
        
        let newDaily: Projects = Projects(uniqueID: uniqueID, name: name, startDate: startDate, endDate: startDate, hours: "0", description: description!, projectType: .daily, projectComplete: false, projectFeatured: false, pictureID: "")
        
        let taskManager = ProjectManager()
        taskManager.add(task: newDaily)
    }
    
}
