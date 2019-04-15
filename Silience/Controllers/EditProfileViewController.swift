//
//  EditProfileViewController.swift
//  Silience
//
//  Created by Jordan Foster on 15/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class EditProfileViewController: UIViewController {

    @IBOutlet weak var firstNameTextbox: UITextField!
    @IBOutlet weak var secondNameTextbox: UITextField!
    @IBOutlet weak var bioTextbox: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    let profileManager = ProfileManager()
    
    var pictureID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(profileManager.profileCreated()){
            let user = profileManager.getUser()
            
            firstNameTextbox.text = user.firstName
            secondNameTextbox.text = user.secondName
            bioTextbox.text = user.bio
            if(user.pictureID != ""){
                pictureID = user.pictureID
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
                
        if(pictureID != ""){
            let photoManager = PhotoManager()
            photoManager.load()
            
            let asset = photoManager.getPhoto(localID: pictureID)
            
            // Prepare the options to pass when fetching the (photo, or video preview) image.
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            options.progressHandler = { progress, _, _, _ in
                // The handler may originate on a background queue, so
                // re-dispatch to the main queue for UI work.
            }
            
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options,
                                                  resultHandler: { image, _ in
                                                    
                                                    // If the request succeeded, show the image view.
                                                    guard let image = image else { return }
                                                    
                                                    self.profileImage.image = image
            })
        }
    }
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: profileImage.bounds.width * scale, height: profileImage.bounds.height * scale)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ImageSelectorViewController else { fatalError("Unexpected view controller for segue") }
        
        destination.viewType = .profileSelect
        destination.editProfileViewController = self
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        let firstName = firstNameTextbox.text
        let secondName = secondNameTextbox.text
        let bio = bioTextbox.text
        let profileID = pictureID
        
        let updatedUser: User = User(firstName: firstName!, secondName: secondName!, bio: bio!, pictureID: profileID)
        
        profileManager.updateProfile(profileUpdate: updatedUser)
        profileManager.save()
        
        navigationController?.popViewController(animated: true)
    }
    
    func updateProfile(){
        let firstName = firstNameTextbox.text
        let secondName = secondNameTextbox.text
        let bio = bioTextbox.text
        let profileID = pictureID
        
        let updatedUser: User = User(firstName: firstName!, secondName: secondName!, bio: bio!, pictureID: profileID)
        
        profileManager.updateProfile(profileUpdate: updatedUser)
        profileManager.save()
    }
    
}
