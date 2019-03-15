//
//  EditProfileViewController.swift
//  Silience
//
//  Created by Jordan Foster on 15/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var firstNameTextbox: UITextField!
    @IBOutlet weak var secondNameTextbox: UITextField!
    @IBOutlet weak var bioTextbox: UITextView!
    
    let profileManager = ProfileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(profileManager.profileCreated()){
            let user = profileManager.getUser()
            
            firstNameTextbox.text = user.firstName
            secondNameTextbox.text = user.secondName
            bioTextbox.text = user.bio
        }
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        let firstName = firstNameTextbox.text
        let secondName = secondNameTextbox.text
        let bio = bioTextbox.text
        
        let updatedUser: User = User(firstName: firstName!, secondName: secondName!, bio: bio!)
        
        profileManager.updateProfile(profileUpdate: updatedUser)
    }
    
}
