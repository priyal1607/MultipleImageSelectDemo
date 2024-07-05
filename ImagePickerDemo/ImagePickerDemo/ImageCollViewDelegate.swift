//
//  ImageCollViewDelegate.swift
//  ImagePickerDemo
//
//  Created by Priyal on 07/02/24.
//

import Foundation
import UIKit

class ImageCollViewDelegate: NSObject {
    
    typealias T = ArrImageModel
    typealias col = UICollectionView
    typealias del = ColViewDelegate?
    typealias vc = UIViewController
    
    internal var arrSource: [T]
    internal var colvw: col
    internal weak var delegate: del
    internal weak var vc:vc?
    internal var isFromvideo : Bool?

    let kNumberOfItemsInOneRow: CGFloat = 2
    let kEdgeInset:CGFloat = 10
    let minimumInterItemandLinespacing:CGFloat = 10
    var arrSelect : [ArrImageModel] = []
    var arrLatestSel : [ArrImageModel] = []
    var completion: (([ArrImageModel], [ArrImageModel]) -> Void)?
    
    //MARK:- Initializers
    required init(arrData: [T], delegate: ColViewDelegate, col: UICollectionView,vc:vc , arrSel : [ArrImageModel] , arrLatestSel : [ArrImageModel] ,isFromvideo:Bool ) {
        arrSource = arrData
        self.arrSelect = arrSel
        self.arrLatestSel = arrLatestSel
        colvw = col
        self.isFromvideo = isFromvideo
        self.delegate = delegate
        self.vc = vc
        super.init()
        setupCol()
    }
    
    fileprivate func setupCol(){
        DispatchQueue.main.async {
            self.colvw.register(UINib(nibName: "ImageCollViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollViewCell")
            self.colvw.dataSource = self
            self.colvw.delegate = self
            self.colvw.reloadData()
        }
    }
    
    func reload(arr:[T] , arrSel : [ArrImageModel] , arrLatestSel : [ArrImageModel] , isFromvideo:Bool ){
        arrSource = arr
        self.arrSelect = arrSel
        self.isFromvideo = isFromvideo
        self.arrLatestSel = arrLatestSel
        DispatchQueue.main.async { [self] in
            colvw.reloadData()
        }
    }
}

extension ImageCollViewDelegate:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFromvideo == true {
            delegate?.didSelect!(colView: colvw, atIndexPath: indexPath)
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollViewCell {
                let imageModel = arrSource[indexPath.row]
                if arrSelect.contains(where: { $0.asset.localIdentifier == imageModel.asset.localIdentifier }) {
                    // Deselect the cell
                    if let index = arrSelect.firstIndex(where: { $0.asset.localIdentifier == imageModel.asset.localIdentifier }) {
                        cell.img.layer.borderWidth = 0
                        arrSelect.remove(at: index)
                    }
                } else {
                    if arrSelect.count < 5 {
                        // Select the cell
                        cell.img.layer.borderWidth = 3
                        arrSelect.append(imageModel)
                        arrLatestSel.append(imageModel)
                    } else {
                        print("not")
                    }
                }
                collectionView.reloadItems(at: [indexPath])
                completion?(arrSelect, arrLatestSel)
                delegate?.didSelect!(colView: colvw, atIndexPath: indexPath)
            }
        }
    }
}
extension ImageCollViewDelegate:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollViewCell", for: indexPath) as! ImageCollViewCell
        let image = arrSource[indexPath.row]
        cell.configureCell(asset: image)
        if arrSelect.contains(where: { $0.asset == image.asset }) {
                cell.img.layer.borderWidth = 3
            } else {
                cell.img.layer.borderWidth = 0
            }
        return cell
    }
}


//MARK:- UICollectionViewDelegateFlowLayout Methods
extension ImageCollViewDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemandLinespacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemandLinespacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (UIScreen.main.bounds.width - 10) / 3.5 , height: (UIScreen.main.bounds.width - 10) / 3.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: kEdgeInset, left: kEdgeInset, bottom: kEdgeInset, right: kEdgeInset)
    }
}

