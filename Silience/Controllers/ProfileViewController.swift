//
//  ProjectTableViewController.swift
//  Silience
//
//  Created by Jordan Foster on 13/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class ProfileViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileFirstName: UILabel!
    @IBOutlet weak var profileSecondName: UILabel!
    @IBOutlet weak var profileBio: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var featuredButton: UIButton!
    @IBOutlet weak var workingProgressButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    
    let featuredGreen = UIImage(named: "Featured.png")
    let featuredRed = UIImage(named: "Featured Red.png")
    let completedGreen = UIImage(named: "Completed.png")
    let completedRed = UIImage(named: "Completed Red.png")
    let workingprogressGreen = UIImage(named: "Working Progress.png")
    let workingprogressRed = UIImage(named: "Working Progress Red.png")
    
    var projects = [Projects]()
    let profileManager = ProfileManager()
    
    var filterFeatured: Bool = true
    var filterCompleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadProjects()
        
        if(profileManager.profileCreated()){
            let user = profileManager.getUser()
            
            profileFirstName.text = user.firstName
            profileSecondName.text = user.secondName
            profileBio.text = user.bio
            
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
                                                        
                                                        self.profileImage.image = image
                })
            }
        }
    }
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: profileImage.bounds.width * scale, height: profileImage.bounds.height * scale)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "EditProjectView"){
            guard let destination = segue.destination as? EditProjectViewController else { fatalError("Unexpected view controller for segue") }
            
            guard let tableViewCell = sender as? ProfileTableViewCell else { fatalError("Unexpected sender for segue") }
            
            let uniqueID = tableViewCell.uniqueID
            destination.uniqueID = uniqueID
            
        }
    }
    
    func loadProjects(){
        
        projects.removeAll()
        
        for project in ProjectManager.projectsArray {
            
            if(filterFeatured){
                if(project.projectFeatured){
                    projects.append(project)
                }
            }else if(filterCompleted){
                if(project.projectComplete){
                    projects.append(project)
                }
            }else{
                if(!project.projectComplete){
                    projects.append(project)
                }
            }
        }
        
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func clearSelectedButton(){
        featuredButton.setImage(featuredGreen, for: UIControl.State.normal)
        workingProgressButton.setImage(workingprogressGreen, for: UIControl.State.normal)
        completedButton.setImage(completedGreen, for: UIControl.State.normal)
    }
    
    @IBAction func featuredClicked(_ sender: Any) {
        clearSelectedButton()
        featuredButton.setImage(featuredRed, for: UIControl.State.normal)
        filterFeatured = true
        filterCompleted = false
        loadProjects()
    }
    
    @IBAction func workingClicked(_ sender: Any) {
        clearSelectedButton()
        workingProgressButton.setImage(workingprogressRed, for: UIControl.State.normal)
        filterFeatured = false
        filterCompleted = false
        loadProjects()
    }
    
    @IBAction func completedClicked(_ sender: Any) {
        clearSelectedButton()
        completedButton.setImage(completedRed, for: UIControl.State.normal)
        filterFeatured = false
        filterCompleted = true
        loadProjects()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Customize custome cell
        let cellIdentifier = "reuseCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProfileTableViewCell else {
            fatalError("The dequeued cell is not an instance of ProfileTableViewCell.")
        }
        
        let project = projects[indexPath.row]
        
        cell.projectName.text = project.name
        cell.projectStart.text = project.startDate
        cell.projectEnd.text = project.endDate
        cell.projectDescription.text = project.description
        cell.uniqueID = project.uniqueID
        
        if(project.pictureID != ""){
            let photoManager = PhotoManager()
            photoManager.load()
            
            let asset = photoManager.getPhoto(localID: project.pictureID)
            
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
                                                    
                                                    cell.projectImage.image = image
            })
        }
        
        return cell
    }
}
