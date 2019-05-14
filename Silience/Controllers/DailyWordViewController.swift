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
    @IBOutlet weak var dailyWordImage: UIImageView!
    
    var pictureID: String = ""
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        print(pictureID)
        if(pictureID != ""){
            
            let photoManager = PhotoManager()
            photoManager.load()
            
            let asset = photoManager.getPhoto(localID: pictureID)
            
            // Prepare the options to pass when fetching the (photo, or video preview) image.
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            options.progressHandler = { progress, _, _, _ in
                // The handler may originate on a background queue, so
                // re-dispatch to the main queue for UI work.
            }
            
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options,
                                                  resultHandler: { image, _ in
                                                    
                                                    // If the request succeeded, show the image view.
                                                    guard let image = image else { return }
                                                    
                                                    self.dailyWordImage.image = image
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameText.resignFirstResponder()
        descriptionText.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier != "home"){
            guard let destination = segue.destination as? ImageSelectorViewController else { fatalError("Unexpected view controller for segue") }
            
            destination.viewType = .dailySelect
            destination.dailyWordViewController = self

        }
    }
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: dailyWordImage.bounds.width * scale, height: dailyWordImage.bounds.height * scale)
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
        
        let newDaily: Projects = Projects(uniqueID: uniqueID, name: name, startDate: startDate, endDate: startDate, hours: "0", description: description!, projectType: .daily, projectComplete: true, projectFeatured: false, pictureID: pictureID)
        
        let taskManager = ProjectManager()
        taskManager.add(task: newDaily)
    }
    
}
