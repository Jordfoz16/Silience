//
//  PhotoManager.swift
//  Silience
//
//  Created by Jordan Foster on 29/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class PhotoManager: UIActivity{
    
    var fetchResult: PHFetchResult<PHAsset>!
    
    fileprivate let imageManager = PHCachingImageManager()
    
    func load(){
        PHPhotoLibrary.shared().register(self)
        
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
            
        }
    }
    
    func getPhoto(localID: String) -> PHAsset{
        
        var asset: PHAsset = PHAsset()
        
        for index in 0...fetchResult.count - 1 {
            if(fetchResult.object(at: index).localIdentifier == localID){
                asset = fetchResult.object(at: index)
            }
        }
        
        return asset
    }
    
}

extension PhotoManager: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: fetchResult)
            else { return }
        
        // Change notifications may originate from a background queue.
        // As such, re-dispatch execution to the main queue before acting
        // on the change, so you can update the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            fetchResult = changes.fetchResultAfterChanges
        }
    }
}
