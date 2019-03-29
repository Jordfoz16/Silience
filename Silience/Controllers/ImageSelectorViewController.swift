//
//  ImageViewerViewController.swift
//  Silience
//
//  Created by Jordan Foster on 27/03/2019.
//  Copyright © 2019 Silience. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class ImageSelectorViewController: UICollectionViewController {
    
    enum viewTypes {
        case view
        case profileSelect
    }
    
    var viewType: viewTypes = .view
    
    var fetchResult: PHFetchResult<PHAsset>!
    //var assetCollection: PHAssetCollection!
    //var availableWidth: CGFloat = 0
    
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.shared().register(self)
        
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        }
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Determine the size of the thumbnails to request from the PHCachingImageManager.
        let scale = UIScreen.main.scale
        let cellSize = collectionViewFlowLayout.itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let asset = fetchResult.object(at: indexPath.item)
        // Dequeue a GridViewCell.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridViewCell", for: indexPath) as? ImageCollectionViewCell
            else { fatalError("Unexpected cell in collection view") }
        
        // Request an image for the asset from the PHCachingImageManager.
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // UIKit may have recycled this cell by the handler's activation time.
            // Set the cell's thumbnail image only if it's still showing the same asset.
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if(viewType == .view){
            let imageViewController = storyBoard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
            
            imageViewController.asset = fetchResult.object(at: indexPath.item)
            self.show(imageViewController, sender: self)
            
        }else if(viewType == .profileSelect){
            let editProfileViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            
            //editProfileViewController.pictureID = fetchResult.object(at: indexPath.item).localIdentifier
            
            editProfileViewController.pictureID = fetchResult.object(at: indexPath.item).localIdentifier
            self.show(editProfileViewController, sender: self)
        }
    }
    
//    //Passing the image to the ImageViewController
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let destination = segue.destination as? ImageViewController else { fatalError("Unexpected view controller for segue") }
//        guard let collectionViewCell = sender as? UICollectionViewCell else { fatalError("Unexpected sender for segue") }
//
//        let indexPath = collectionView.indexPath(for: collectionViewCell)!
//        destination.asset = fetchResult.object(at: indexPath.item)
//
//    }
}

extension ImageSelectorViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: fetchResult)
            else { return }
        
        // Change notifications may originate from a background queue.
        // As such, re-dispatch execution to the main queue before acting
        // on the change, so you can update the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            fetchResult = changes.fetchResultAfterChanges
            // If we have incremental changes, animate them in the collection view.
            if changes.hasIncrementalChanges {
                guard let collectionView = self.collectionView else { fatalError() }
                // Handle removals, insertions, and moves in a batch update.
                collectionView.performBatchUpdates({
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                to: IndexPath(item: toIndex, section: 0))
                    }
                })
                // We are reloading items after the batch update since `PHFetchResultChangeDetails.changedIndexes` refers to
                // items in the *after* state and not the *before* state as expected by `performBatchUpdates(_:completion:)`.
                if let changed = changes.changedIndexes, !changed.isEmpty {
                    collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                }
            } else {
                // Reload the collection view if incremental changes are not available.
                collectionView.reloadData()
            }
        }
    }
}
