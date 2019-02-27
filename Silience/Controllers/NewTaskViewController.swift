//
//  FirstViewController.swift
//  Silience
//
//  Created by Jordan Foster on 19/02/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var timeTextBox: UITextField!
    @IBOutlet weak var startDateTextBox: UITextField!
    @IBOutlet weak var endDateTextBox: UITextField!
    @IBOutlet weak var minutesLabel: UILabel!
    
    private var datePicker: UIDatePicker?
    private var startDate: Date = Date.init()
    private var endDate: Date = Date.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Date Picker Setup for the date input fields
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        
        //Tap gesture to close the datepicker when date is selected
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestrueRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        //Setting the inputs to the date picker
        startDateTextBox.inputView = datePicker
        endDateTextBox.inputView = datePicker
        
        //Making the keyboard to show
        nameTextBox.becomeFirstResponder()
    }
    
    @objc func dateChange(datePicker: UIDatePicker){
        //Formatting the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        //Changing the correct date textbox
        if(startDateTextBox.isEditing){
            startDate = datePicker.date
            startDateTextBox.text = dateFormatter.string(from: datePicker.date)
        }else if(endDateTextBox.isEditing){
            endDate = datePicker.date
            endDateTextBox.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc func viewTapped(gestrueRecognizer: UITapGestureRecognizer){
        //Close the datepicker when the tap gesture
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextBox.resignFirstResponder()
        timeTextBox.resignFirstResponder()
        
    }
    
    @IBAction func changedHours(_ sender: Any) {
        updateWorkLoad()
    }
    
    @IBAction func changeStartDate(_ sender: Any) {
        updateWorkLoad()
    }
    
    @IBAction func changeEndDate(_ sender: Any) {
        updateWorkLoad()
    }
    
    func updateWorkLoad(){
        //Check data has been entered
        if(timeTextBox.text == "" || startDateTextBox.text == "" || endDateTextBox.text == ""){
            return
        }
        let hours:Double = Double(timeTextBox.text!)!
        
        //Amount of days between the dates
        
        if(endDate != startDate){
            let dayGap = (endDate.timeIntervalSince(startDate)) / 60 / 60 / 24
            let timePerDay = Int((hours/dayGap)*60)
            
            minutesLabel.text = String(timePerDay) + " min/day"
        }else{
            minutesLabel.text = "N/a"
        }
        
    }
    
    @IBAction func addNewTask(sender: Any) {
        
        let fileManager = File()
        let jsonParser = ParseJSON()
        
        let name = nameTextBox.text
        let startDate = startDateTextBox.text
        let endDate = endDateTextBox.text
        let hours = timeTextBox.text
        let description = "None"
        
        let newTask: Task = Task(name: name!, startDate: startDate!, endDate: endDate!, hours: hours!, description: description)
        
        jsonParser.addTask(task: newTask)
        jsonParser.encodeJSON()
        
        fileManager.writeFile(writeString: jsonParser.jsonToString(), fileName: "Tasks", fileExtension: "json")
    }
}
