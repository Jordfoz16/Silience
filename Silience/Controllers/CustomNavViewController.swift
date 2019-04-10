//
//  TestViewController.swift
//  Silience
//
//  Created by Jordan Foster on 10/04/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit

class CustomNavViewController: UITabBarController {

    @IBOutlet weak var navBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarItems = navBar.items
        
        //Allows the navigation bar to use colours
        for index in navBarItems ?? [UITabBarItem()] {
            index.image = index.image?.withRenderingMode(.alwaysOriginal)
            index.selectedImage = index.selectedImage?.withRenderingMode(.alwaysOriginal)
        }
        
    }
}
