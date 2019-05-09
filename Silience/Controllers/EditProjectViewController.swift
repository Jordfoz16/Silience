//
//  EditProjectViewController.swift
//  Silience
//
//  Created by Jordan Foster on 29/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit

class EditProjectViewController: UIViewController {
    
    @IBOutlet weak var nameTextbox: UITextField!
    @IBOutlet weak var startDateTextbox: UITextField!
    @IBOutlet weak var endDateTextbox: UITextField!
    @IBOutlet weak var descriptionTextBox: UITextView!
    @IBOutlet weak var featuredSwitch: UISwitch!
    @IBOutlet weak var completedSwitch: UISwitch!
    @IBOutlet weak var workloadLabel: UILabel!
    @IBOutlet weak var hoursTextbox: UITextField!
    @IBOutlet weak var chooseImage: UIButton!
    
    var uniqueID: Int = 0
    var pictureID: String = ""
    
    let projectManager = ProjectManager()
    
    private var datePicker: UIDatePicker?
    private var startDate: Date = Date.init()
    private var endDate: Date = Date.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(ProjectManager.projectsArray)
        
        //Date Picker Setup for the date input fields
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        
        //Tap gesture to close the datepicker when date is selected
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestrueRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        //Setting the inputs to the date picker
        startDateTextbox.inputView = datePicker
        endDateTextbox.inputView = datePicker
        
        //Setting the default values for the project from the uniqueID
        let project = projectManager.filterByID(uniqueID: uniqueID)
        
        nameTextbox.text = project.name
        hoursTextbox.text = project.hours
        startDateTextbox.text = project.startDate
        endDateTextbox.text = project.endDate
        descriptionTextBox.text = project.description
        completedSwitch.isOn = project.projectComplete
        featuredSwitch.isOn = project.projectFeatured
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ImageSelectorViewController else { fatalError("Unexpected view controller for segue") }
        
        destination.viewType = .projectSelect
        destination.editProjectViewController = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextbox.resignFirstResponder()
        descriptionTextBox.resignFirstResponder()
        hoursTextbox.resignFirstResponder()
    }
    
    @objc func dateChange(datePicker: UIDatePicker){
        //Formatting the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        //Changing the correct date textbox
        if(startDateTextbox.isEditing){
            startDate = datePicker.date
            startDateTextbox.text = dateFormatter.string(from: datePicker.date)
        }else if(endDateTextbox.isEditing){
            endDate = datePicker.date
            endDateTextbox.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc func viewTapped(gestrueRecognizer: UITapGestureRecognizer){
        //Close the datepicker when the tap gesture
        view.endEditing(true)
    }
    
    //Set the date picker to the start date
    @IBAction func startDateSelected(_ sender: Any) {
        let date = stringToDate(dateString: startDateTextbox.text!)
        datePicker?.setDate(date, animated: true)
    }
    
    //Set the date picker to the end date
    @IBAction func endDateSelected(_ sender: Any) {
        let date = stringToDate(dateString: endDateTextbox.text!)
        datePicker?.setDate(date, animated: true)
    }
    
    //Convert the string into a date for the date picker
    func stringToDate(dateString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        guard let date = dateFormatter.date(from: dateString) else {
            fatalError("Date Converstion Failed")
        }
        
        return date
    }
    
    @IBAction func updateProject(_ sender: Any) {
        let projectIndex = projectManager.getIndex(uniqueID: uniqueID)
        
        let name = nameTextbox.text
        let startDate = startDateTextbox.text
        let endDate = endDateTextbox.text
        let hours = hoursTextbox.text
        let description = descriptionTextBox.text
        let projectType = ProjectType.project
        let projectComplete = completedSwitch.isOn
        let projectFeatured = featuredSwitch.isOn
        
        let updatedProject = Projects(uniqueID: uniqueID, name: name!, startDate: startDate!, endDate: endDate!, hours: hours!, description: description!, projectType: projectType, projectComplete: projectComplete, projectFeatured: projectFeatured, pictureID: pictureID)
        
        ProjectManager.projectsArray[projectIndex] = updatedProject
        
        projectManager.save()
        
        navigationController?.popViewController(animated: true)
    }
}
