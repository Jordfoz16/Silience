//
//  CalendarControllerView.swift
//  Silience
//
//  Created by Jordan Foster on 12/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let selectedDateColour = UIColor.black
    let currentMonthColour = UIColor.black
    let previousMonthColour = UIColor.gray
    
    let formatter = DateFormatter()
    let projectManager = ProjectManager()
    var filteredProjects = [Projects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func setupCalendar() {
        //Setting spacing for the cells
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //Setting default values of calendar labels
        calendarView.visibleDates { (visableDates) in
            self.setupViewOfCalendar(from: visableDates)
        }
    }
    
    //Added the year and month to the view
    func setupViewOfCalendar(from visableDates: DateSegmentInfo){
        let date = visableDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.yearLabel.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.monthLabel.text = self.formatter.string(from: date)
    }
    
    //Adding the colours to selected cells
    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CalendarCell else { return }

        if(cellState.isSelected){
            validCell.selectedView.isHidden = false
        }else{
            validCell.selectedView.isHidden = true
        }
    }
    
    //Changing of the colours of the text depending on the month
    func handleCellTextColour(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CalendarCell else { return }
        
        if(cellState.isSelected){
            validCell.dateLabel.textColor = selectedDateColour
        }else{
            if(cellState.dateBelongsTo == .thisMonth){
                validCell.dateLabel.textColor = currentMonthColour
            }else{
                validCell.dateLabel.textColor = previousMonthColour
            }
        }
    }
    
    //Addes colours to the cells that have project on them
    func handleEventColour(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CalendarCell else { return }
        
        if(cellState.dateBelongsTo == .thisMonth){
            let cellDate = formatDate(date: cellState.date)
            
            if(projectManager.isEvent(date: cellDate)){
                validCell.eventView.isHidden = false
            }else{
                validCell.eventView.isHidden = true
            }
        }
    }
    
    //Date formatting
    func formatDate(date: Date) -> String{
        
        formatter.dateFormat = "dd/MM/YYYY"
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "reuseCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CalendarTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let project = filteredProjects[indexPath.row]
        
        cell.projectName.text = project.name
        cell.projectDescription.text = project.description
        
        
        return cell
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let startDate = formatter.date(from: "01/03/2018")!
        let endDate = formatter.date(from: "01/12/2020")!
        
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, calendar: Calendar.current)
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    // Displays the cell
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // The code here is the same as cellForItem function
        let cell = cell as! CalendarCell
        sharedFunctionToConfigureCell(cell: cell, cellState: cellState, date: date)

    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CalendarCell
        sharedFunctionToConfigureCell(cell: cell, cellState: cellState, date: date)
        
        return cell
    }
    
    //Configure Cell
    func sharedFunctionToConfigureCell(cell: CalendarCell, cellState: CellState, date: Date) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColour(view: cell, cellState: cellState)
        handleEventColour(view: cell, cellState: cellState)
        
        cell.dateLabel.text = cellState.text
    }
    
    //Gets called when selected a cell
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColour(view: cell, cellState: cellState)
        filteredProjects = projectManager.filterByDate(date: formatDate(date: date))
        tableView.reloadData()
        
    }
    
    //Gets called when deselected a cell
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColour(view: cell, cellState: cellState)

    }
    
    //Gets called when users scrolls calendar
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewOfCalendar(from: visibleDates)
    }
    
}
