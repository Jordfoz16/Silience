//
//  HomeViewController.swift
//  Silience
//
//  Created by Jordan Foster on 24/04/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class HomeViewController: UIViewController {

    //Word of the day box
    @IBOutlet weak var wordView: UIView!
    @IBOutlet weak var lblWordOfTheDay: UILabel!
    @IBOutlet weak var lblWordDate: UILabel!
    
    //Calendar box
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    
    //Profile box
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var lblWorkingProgress: UILabel!
    @IBOutlet weak var lblFeatured: UILabel!
    @IBOutlet weak var lblCompleted: UILabel!
    
    let dailyWord = DailyWordsManager()
    let profileManager = ProfileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get current date
        let date = Date()
        let formatter = DateFormatter()
        
        //-----------------Word of the day box------------------
        
        let wordTapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.wordTapped(gesture:)))
        
        wordView.addGestureRecognizer(wordTapGesture)
        
        //Get random word
        lblWordOfTheDay.text = dailyWord.getRandomWord()
        
        formatter.dateFormat = "MMMM dd, yyyy"
        lblWordDate.text = formatter.string(from: date)
        
        //-----------------Calendar box------------------
        
        let calendarGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.calendarTapped(gesture:)))
        
        calendarView.addGestureRecognizer(calendarGesture)
        
        //Get the month
        formatter.dateFormat = "MMM"
        lblMonth.text = formatter.string(from: date)
        
        //Get the year
        formatter.dateFormat = "yyyy"
        lblYear.text = formatter.string(from: date)
        
        //Get the day
        formatter.dateFormat = "dd"
        lblDate.text = formatter.string(from: date)
        
        //-----------------Profile box------------------
        
        let profileGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.profileTapped(gesture:)))
        
        profileView.addGestureRecognizer(profileGesture)
        
        loadProfilePicture()
        loadProjects()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProfilePicture()
        loadProjects()
    }
    
    func loadProjects(){
        var workingProgressCount = 0
        var featuredCount = 0
        var completedCount = 0
        
        ProjectManager()
        
        for project in ProjectManager.projectsArray {
            if(project.projectComplete){
                completedCount += 1
            }else{
                workingProgressCount += 1
            }
            
            if(project.projectFeatured){
                featuredCount += 1
            }
        }
        
        lblWorkingProgress.text = String(workingProgressCount) + " Work in Progress"
        lblCompleted.text = String(completedCount) + " Completed Projects"
        lblFeatured.text = String(featuredCount) + " Featured Projects"
    }
    
    func loadProfilePicture(){
        if(profileManager.profileCreated()){
            let pictureID = profileManager.getUser().pictureID
            
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
                                                        
                                                        self.profilePicture.image = image
                })
            }
        }
    }
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: profilePicture.bounds.width * scale, height: profilePicture.bounds.height * scale)
    }
    
    @objc func wordTapped(gesture: UIGestureRecognizer){
        tabBarController?.selectedIndex = 1
    }
    
    @objc func calendarTapped(gesture: UIGestureRecognizer){
        tabBarController?.selectedIndex = 2
    }
    
    @objc func profileTapped(gesture: UIGestureRecognizer){
        tabBarController?.selectedIndex = 3
    }
}
