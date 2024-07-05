//
//  GroupImageVC.swift
//  ImagePickerDemo
//
//  Created by Priyal on 07/02/24.
//

import UIKit
import Photos

class GroupImageVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    var imageGroups: [PHAssetCollection] = []
    var imagesByGroup: [PHFetchResult<PHAsset>] = []
    var groupImageDataSourceDelegate : GroupImageDataSourceDelegate!
    var selImg : [ArrImageModel] = []
    var isFromVideo : Bool = false
    var arrLatestSelected : [ArrImageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.loadGroups()
        setUpTblView()
    }
    // Do any additional setup after loading the view.
    
    fileprivate func setUpTblView(){
        if self.groupImageDataSourceDelegate == nil {
            self.groupImageDataSourceDelegate = GroupImageDataSourceDelegate(arrData: imageGroups, delegate: self, tbl: tblView, vc: self, arrData1: imagesByGroup)
            self.groupImageDataSourceDelegate.reload(arr: imageGroups, arr1: imagesByGroup)
        }
       
    }
    
    func loadGroups() {
        let fetchOptions = PHFetchOptions()
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
        
        userAlbums.enumerateObjects { [self] (collection, _, _) in
            // Fetch only image assets for the collection
            let imageFetchOptions = PHFetchOptions()
            if isFromVideo {
                imageFetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
            } else {
                imageFetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            }
            let imageAssets = PHAsset.fetchAssets(in: collection, options: imageFetchOptions)
            
            // Check if the collection contains any image assets
            if imageAssets.count > 0 {
                self.imageGroups.append(collection)
                self.imagesByGroup.append(imageAssets)
            }
        }
        
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
       
    @IBAction func btnBackAction(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "PostSelectImg", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "PostSelectImgVC")as! PostSelectImgVC
        for latestItem in arrLatestSelected {
            selImg = selImg.filter { $0.asset.localIdentifier != latestItem.asset.localIdentifier }
        }
        vc.arrImage = selImg
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
extension GroupImageVC : TblViewDelegate {
    func didSelect(tblView: UITableView, atIndexPath: IndexPath) {
        let selectedGroup = imageGroups[atIndexPath.row]
        let selectedGroupAssets = imagesByGroup[atIndexPath.row]
        print("Selected group: \(selectedGroup.localizedTitle ?? "")")
        print("Number of images/video in group: \(selectedGroupAssets.count)")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "ViewController") as! ViewController
        vc.selectedGroup = imageGroups[atIndexPath.row]
        vc.isfromVideo = isFromVideo
        vc.isfromGroup = true
        vc.arrSel = selImg
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
