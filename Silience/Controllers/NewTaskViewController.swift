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
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestrueRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        startDate.inputView = datePicker
        endDate.inputView = datePicker
        nameTextBox.becomeFirstResponder()
    }
    
    @objc func dateChange(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if(startDate.isEditing){
            startDate.text = dateFormatter.string(from: datePicker.date)
        }else if(endDate.isEditing){
            endDate.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc func viewTapped(gestrueRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextBox.resignFirstResponder()
        timeTextBox.resignFirstResponder()
        
    }
}
