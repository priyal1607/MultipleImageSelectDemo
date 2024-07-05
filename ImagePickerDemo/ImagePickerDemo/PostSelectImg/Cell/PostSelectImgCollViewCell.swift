//
//  PostSelectImgCollViewCell.swift
//  ImagePickerDemo
//
//  Created by Priyal on 07/02/24.
//

import UIKit
import Photos

class PostSelectImgCollViewCell: UICollectionViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnDelete.layer.cornerRadius = btnDelete.frame.height / 2
        // Initialization code
    }
    func setUpCollView(){
        
    }
    func configureCell(asset : ArrImageModel){
        if asset.img != nil {
            img.image = asset.img
        } else {
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            
            PHImageManager.default().requestImage(for: asset.asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                self.img.image = image
                asset.img = image
            }
        }
    }
}
