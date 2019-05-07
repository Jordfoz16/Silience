//
//  CalendarTableViewCell.swift
//  Silience
//
//  Created by Jordan Foster on 14/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projectNamelbl: UILabel!
    @IBOutlet weak var projectWordlbl: UILabel!
    @IBOutlet weak var projectDescription: UITextView!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var projectStartDate: UILabel!
    @IBOutlet weak var projectEndDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
