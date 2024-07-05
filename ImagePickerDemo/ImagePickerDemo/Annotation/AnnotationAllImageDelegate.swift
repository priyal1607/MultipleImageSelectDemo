//
//  AnnotationAllImageDelegate.swift
//  ImagePickerDemo
//
//  Created by Priyal on 08/02/24.
//

import Foundation
import UIKit

class AnnotationAllImageDelegate: NSObject {
    
    typealias T = ArrImageModel
    typealias col = UICollectionView
    typealias del = ColViewDelegate?
    typealias vc = UIViewController
    
    internal var arrSource: [T]
    internal var colvw: col
    internal weak var delegate: del
    internal weak var vc:vc?

    let kNumberOfItemsInOneRow: CGFloat = 0
    let kEdgeInset:CGFloat = 0
    let minimumInterItemandLinespacing:CGFloat = 5
    var arrSelect : [ArrImageModel] = []
    var arrdeSelect : [ArrImageModel] = []
    var completion: (([ArrImageModel], [ArrImageModel]) -> Void)?
    var index : Int = 0
    
    //MARK:- Initializers
    required init(arrData: [T], delegate: ColViewDelegate, col: UICollectionView,vc:vc , arrSel : [ArrImageModel]) {
        arrSource = arrData
        self.arrSelect = arrSel
        colvw = col
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
    
    func reload(arr:[T] , arrSel : [ArrImageModel]){
        arrSource = arr
        self.arrSelect = arrSel
        DispatchQueue.main.async { [self] in
            colvw.reloadData()
        }
    }
}

extension AnnotationAllImageDelegate:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for visibleIndexPath in collectionView.indexPathsForVisibleItems {
            if let cell = collectionView.cellForItem(at: visibleIndexPath) as? ImageCollViewCell {
                cell.img.layer.borderWidth = 0
            }
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollViewCell {
            cell.img.layer.borderWidth = 1
        }
        delegate?.didSelect!(colView: colvw, atIndexPath: indexPath)
    }

}
extension AnnotationAllImageDelegate:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrSource.count > 4 {
            return arrSource.count
        } else {
            return arrSource.count + 1
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollViewCell", for: indexPath) as! ImageCollViewCell
        cell.img.layer.cornerRadius = 4
        if indexPath.row == index {
            cell.img.layer.borderWidth = 1
        }else {
            cell.img.layer.borderWidth = 0
        }
        if indexPath.row == arrSource.count {
            cell.img.image = .attachMedia
            cell.img.superview?.backgroundColor = .lightGray
        } else {
            let image = arrSource[indexPath.row]
            cell.configureCell(asset: image)
        }
        return cell
    }
}


//MARK:- UICollectionViewDelegateFlowLayout Methods
extension AnnotationAllImageDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemandLinespacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemandLinespacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (UIScreen.main.bounds.width - 30) / 5 , height: (UIScreen.main.bounds.width - 30) / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: kEdgeInset, left: 5, bottom: kEdgeInset, right: 5)
    }
}

