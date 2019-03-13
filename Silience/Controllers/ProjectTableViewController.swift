//
//  ProjectTableViewController.swift
//  Silience
//
//  Created by Jordan Foster on 13/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit

class ProjectTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var projects = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProjects()
        tableView.dataSource = self
        print(projects)
        tableView.reloadData()
    }
    
    func loadProjects(){
        projects = TaskManager.taskArray
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return TaskManager.taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Customize custome cell
        let cellIdentifier = "reuseCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProjectTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let project = projects[indexPath.row]
        
        cell.projectName.text = project.name
        cell.projectStart.text = project.startDate
        cell.projectEnd.text = project.endDate
        
        
        return cell
    }
}
