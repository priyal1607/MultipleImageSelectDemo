//
//  GroupImageDataSourceDelegate.swift
//  ImagePickerDemo
//
//  Created by Priyal on 07/02/24.
//

import Foundation
import UIKit
import Photos

class GroupImageDataSourceDelegate: NSObject {
    internal var arrSource: [PHAssetCollection]
    internal var arrSource1: [PHFetchResult<PHAsset>]
    internal var tblvw: UITableView
    internal var delegate: TblViewDelegate
    internal var vc: UIViewController?
    
    
    //MARK:- Initializers
    required init(arrData: [PHAssetCollection], delegate: TblViewDelegate, tbl: UITableView,vc:UIViewController, arrData1 : [PHFetchResult<PHAsset>]) {
        arrSource = arrData
        arrSource1 = arrData1
        tblvw = tbl
        self.delegate = delegate
        self.vc = vc
        super.init()
        setupTbl()
    }
    
    fileprivate func setupTbl(){
        tblvw.register(UINib(nibName: "GroupImageTblViewCell", bundle:nil), forCellReuseIdentifier: "GroupImageTblViewCell")
        tblvw.dataSource = self
        tblvw.delegate = self
        setUpBackgroundView()
        self.tblvw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tblvw.reloadData()
        
    }
    
    func reload(arr:[PHAssetCollection] , arr1 :[PHFetchResult<PHAsset>]){
        arrSource = arr
        arrSource1 = arr1
        setUpBackgroundView()
        tblvw.reloadData()
        
    }
    
    private func setUpBackgroundView() {
        if (self.arrSource.count > 0) {
            self.tblvw.backgroundView = nil
        } else {
            
        }
    }
}

extension GroupImageDataSourceDelegate:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelect?(tblView: tblvw, atIndexPath: indexPath)
    }
    
}
extension GroupImageDataSourceDelegate:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupImageTblViewCell", for: indexPath)as! GroupImageTblViewCell
        cell.lblName.text = arrSource[indexPath.row].localizedTitle!  + " (" + getString(anything: (arrSource1[indexPath.row].count)) + ")"
        if let firstImageAsset = arrSource1[indexPath.row].lastObject {
                   let requestOptions = PHImageRequestOptions()
                   requestOptions.isSynchronous = true
                   requestOptions.deliveryMode = .highQualityFormat
                   PHImageManager.default().requestImage(for: firstImageAsset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                       if let image = image {
                           cell.img.image = image
                       }
                   }
               }
        cell.selectionStyle = .none
        return cell
    }
}
