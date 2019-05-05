//
//  CalendarCell.swift
//  Silience
//
//  Created by Jordan Foster on 12/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit
import JTAppleCalendar
class CalendarCell: JTAppleCell {
    
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var isProjectView: UIView!
    @IBOutlet weak var isDailyView: UIView!
}
