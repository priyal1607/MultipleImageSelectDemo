//
//  ViewController.swift
//  ImagePickerDemo
//
//  Created by Priyal on 07/02/24.
//

import UIKit
import Photos

func getString(anything: Any?) -> String
{
    if let any:Any = anything
    {
        if let num = any as? NSNumber
        {
            return num.stringValue
        }
        else if let str = any as? String
        {
            return str
        }
        else if let char = any as? Character
        {
            return "\(char)"
        }
    }
    return ""
}

func getBoolean(anything: Any?) -> Bool
{
    if let any:Any = anything
    {
        if let num = any as? NSNumber
        {
            return num.boolValue
        }
        else if let str = any as? NSString
        {
            return str.boolValue
        }
    }
    return false
}

func getInteger(anything: Any?) -> Int
{
    if let any:Any = anything
    {
        if let num = any as? NSNumber
        {
            return num.intValue
        }
        else if let str = any as? NSString
        {
            return str.integerValue
        }
    }
    return 0
}
class SelectedImages : NSObject{
    var image: UIImage?
        var index : Int?
        var isSelected : Bool?

    init(dict: [String: Any]) {
           if let image = dict["image"] as? UIImage {
               self.image = image
           }
           if let index = dict["index"] as? Int {
               self.index = index
           }
           if let isSelected = dict["isSelected"] as? Bool {
               self.isSelected = isSelected
           }
       }
}

//class SelectedImages: NSObject {
//    var image: UIImage
//    var index : Int
//    var isSelected : Bool = false
//    init(image: UIImage, index: Int,isSelected : Bool ) {
//        self.image = image
//        self.index = index
//        self.isSelected = isSelected
//    }
//    
//    init(dict: [String : Any]) {
//        index = getInteger(anything: dict[index])
//}


class ArrImageModel {
    var asset : PHAsset
    var img : UIImage?
    
    init(asset: PHAsset) {
        self.asset = asset
    }
}
class ViewController: UIViewController {

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var collView: UICollectionView!
    var arrImage : [ArrImageModel] = []
    var imageCollViewDelegate : ImageCollViewDelegate!
    var isfromGroup : Bool = false
    var selectedGroup : PHAssetCollection?
    var arrSel : [ArrImageModel] = []
    var comp : (([ArrImageModel]) -> ())!
    var latestSel : [ArrImageModel] = []
    var isfromVideo : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        if isfromVideo {
            btnDone.isHidden = true
        } else {
            btnDone.isHidden = false
        }
                if !isfromGroup {
                    self.loadImages()
                    setUpCollView()
                    isfromGroup = false
                } else {
                    self.loadImagesFromGroup()
                    setUpCollView()
        }
    }
    
    fileprivate func setUpCollView(){
        if self.imageCollViewDelegate == nil {
            self.imageCollViewDelegate = ImageCollViewDelegate(arrData: arrImage, delegate: self, col: collView, vc: self, arrSel: arrSel, arrLatestSel: latestSel, isFromvideo: isfromVideo)
            imageCollViewDelegate.completion = { [self]selArr , latestSelArr in
                arrSel = selArr
                latestSel = latestSelArr
            }} else {
                self.imageCollViewDelegate.reload(arr: arrImage, arrSel: arrSel, arrLatestSel: latestSel, isFromvideo: isfromVideo)
            }
    }
       
    func loadImagesFromGroup() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        //let fetchResult = PHAsset.fetchAssets(in: selectedGroup!, options: fetchOptions)
        let imageFetchOptions = PHFetchOptions()
        if isfromVideo {
            imageFetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        } else {
            imageFetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        }
        let imageAssets = PHAsset.fetchAssets(in: selectedGroup!, options: imageFetchOptions)
        imageAssets.enumerateObjects { (asset, _, _) in
            self.arrImage.append(.init(asset: asset))
        }
        DispatchQueue.main.async {
            self.collView.reloadData()
        }
    }
    func loadImages() {
        if isfromGroup {
        } else {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            if isfromVideo {
                let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
                fetchResult.enumerateObjects { (asset, _, _) in
                    let requestOptions = PHImageRequestOptions()
                    requestOptions.isSynchronous = true
                    requestOptions.deliveryMode = .highQualityFormat
                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                        if image != nil {
                            self.arrImage.append(.init(asset: asset))
                        }
                    }
                }
            } else {
                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                fetchResult.enumerateObjects { (asset, _, _) in
                    let requestOptions = PHImageRequestOptions()
                    requestOptions.isSynchronous = true
                    requestOptions.deliveryMode = .highQualityFormat
                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                        if image != nil {
                            self.arrImage.append(.init(asset: asset))
                        }
                    }
                }
            }
            
            
            DispatchQueue.main.async {
                self.collView.reloadData()
            }
        }
    }
      
   
    @IBAction func btnBackAction(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "GroupImage", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "GroupImageVC")as! GroupImageVC
        vc.isFromVideo = isfromVideo
        vc.selImg = arrSel
        vc.arrLatestSelected = latestSel
        self.navigationController?.pushViewController(vc, animated: false
        )
    }
    @IBAction func btnDoneAction(_ sender: UIButton) {
        if arrSel.count > 0 {
            let storyBoard = UIStoryboard(name: "Annotation", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "AnnotationVC")as! AnnotationVC
            vc.arrImage = arrSel
            vc.arrlatest = latestSel
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            let storyBoard = UIStoryboard(name: "PostSelectImg", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "PostSelectImgVC")as! PostSelectImgVC
            vc.arrImage = arrSel
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

extension ViewController : ColViewDelegate {
    func didSelect(colView: UICollectionView, atIndexPath: IndexPath) {
        if isfromVideo {
            let storyBoard = UIStoryboard(name: "VideoTrimmer", bundle: nil)
            //            let vc = storyBoard.instantiateViewController(identifier: "VideoTrimmerVC")as! VideoTrimmerVC
            PHImageManager.default().requestAVAsset(forVideo: arrImage[atIndexPath.row].asset, options: nil) { asset, audioMix, info in
                if let temp = asset as? AVURLAsset {
                    DispatchQueue.main.async {
                        let vc = storyBoard.instantiateViewController(withIdentifier: "VideoTrimmerVC") as! VideoTrimmerVC
                        vc.videoUrl = temp
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }
                // self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
}
