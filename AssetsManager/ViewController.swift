//
//  ViewController.swift
//  AssetsManager
//
//  Created by Sarith Slonh on 1/22/16.
//  Copyright © 2016 sslonh. All rights reserved.
//

import UIKit
import Photos

class ViewController: UICollectionViewController {

    var allAssets:PHFetchResult? //fetch results for assets
    var dimension: CGFloat? //width of thumbnails
    
    let assetCountPerRow:CGFloat = 4 //how many assets you want displayed per row
    let backgroundColor = UIColor.whiteColor()
    let refreshTintColor = UIColor.blueColor()
    
    let refreshControl = UIRefreshControl()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = self.backgroundColor
        self.dimension = UIScreen.mainScreen().bounds.size.width / assetCountPerRow
        
        self.refreshControl.tintColor = self.refreshTintColor
        self.refreshControl.addTarget(self, action: Selector("loadAssets"), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView?.addSubview(self.refreshControl)
        
        self.loadAssets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: View Controller Functions
    func loadAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.allAssets = PHAsset.fetchAssetsWithOptions(fetchOptions)
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView?.reloadData()
    }
    
    //MARK: UICollectionViewController Delegates
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let assets = self.allAssets {
            return assets.count
        }
        else {
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "AssetCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! AssetCell
        let asset = self.allAssets?.objectAtIndex(indexPath.row) as! PHAsset
        
        cell.setAsset(asset, imageDimension: CGSize(width: self.dimension!, height: self.dimension!))
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        cell.selected = true
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let confirm = UIAlertController(title: "", message: "Delete?", preferredStyle: UIAlertControllerStyle.Alert)
        confirm.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction?) -> Void in
        }))
        confirm.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction?) -> Void in
            let asset = self.allAssets?.objectAtIndex(indexPath.row) as! PHAsset
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                PHAssetChangeRequest.deleteAssets([asset])
                }, completionHandler: { (success, error) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.loadAssets()
                        self.collectionView?.reloadData()
                    })
            })
        }))
        self.presentViewController(confirm, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.dimension! - 1, height: self.dimension!)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
}

