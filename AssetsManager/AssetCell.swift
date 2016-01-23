//
//  AssetCell.swift
//  AssetsManager
//
//  Created by Sarith Slonh on 1/23/16.
//  Copyright © 2016 sslonh. All rights reserved.
//

import Foundation
import Photos

class AssetCell : UICollectionViewCell {
    
    @IBOutlet var imgThumbnail: UIImageView!
    
    func setAsset(asset: PHAsset, imageDimension: CGSize) {
        
        let manager = PHImageManager.defaultManager()
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .HighQualityFormat
        manager.requestImageForAsset(asset, targetSize: imageDimension, contentMode: .AspectFit, options: requestOptions, resultHandler: { (image, info) -> Void in
            self.imgThumbnail.image = image
        })
        
    }
}