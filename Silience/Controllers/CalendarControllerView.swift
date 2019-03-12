//
//  CalendarControllerView.swift
//  Silience
//
//  Created by Jordan Foster on 12/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarControllerView: UIViewController {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
}

extension CalendarControllerView: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let persianCalendar = Calendar(identifier: .persian)
        
        let testFotmatter = DateFormatter()
        testFotmatter.dateFormat = "yyyy/MM/dd"
        testFotmatter.timeZone = persianCalendar.timeZone
        testFotmatter.locale = persianCalendar.locale
        
        let startDate = testFotmatter.date(from: "2017/01/01")!
        let endDate = testFotmatter.date(from: "2017/09/30")!
        
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, calendar: persianCalendar)
        return parameters
    }
}

extension CalendarControllerView: JTAppleCalendarViewDelegate {
    
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
        
        if(cellState.isSelected){
            cell.selectedView.isHidden = false
        }else{
            cell.selectedView.isHidden = true

        }
        
        cell.dateLabel.text = cellState.text
    }
    
    //Selected a cell
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        
        validCell.selectedView.isHidden = false
    }
    
    //Deselected a cell
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        
        validCell.selectedView.isHidden = true
        
    }
    
}
