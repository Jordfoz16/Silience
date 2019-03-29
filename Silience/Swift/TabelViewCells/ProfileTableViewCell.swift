//
//  ProjectTableTableViewCell.swift
//  Silience
//
//  Created by Jordan Foster on 13/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var projectStart: UILabel!
    @IBOutlet weak var projectEnd: UILabel!
    @IBOutlet weak var projectDescription: UITextView!
    
    var uniqueID: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
