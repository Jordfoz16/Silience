//
//  ProjectTableViewController.swift
//  Silience
//
//  Created by Jordan Foster on 13/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileFirstName: UILabel!
    @IBOutlet weak var profileSecondName: UILabel!
    @IBOutlet weak var profileBio: UILabel!
    
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
        }
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
                projects.append(project)
            }
        }
        
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @IBAction func featuredClicked(_ sender: Any) {
        filterFeatured = true
        filterCompleted = false
        loadProjects()
    }
    
    @IBAction func workingClicked(_ sender: Any) {
        filterFeatured = false
        filterCompleted = false
        loadProjects()
    }
    
    @IBAction func completedClicked(_ sender: Any) {
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
        
        
        return cell
    }
    
    @IBAction func getProfileArray(_ sender: Any) {
        
        print(ProfileManager.profile)
    }
}
