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
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = self.backgroundColor
        self.dimension = UIScreen.mainScreen().bounds.size.width / assetCountPerRow
        self.loadAssets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: View Controller Functions
    private func loadAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.allAssets = PHAsset.fetchAssetsWithOptions(fetchOptions)
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

