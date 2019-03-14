//
//  CalendarTableViewCell.swift
//  Silience
//
//  Created by Jordan Foster on 14/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
